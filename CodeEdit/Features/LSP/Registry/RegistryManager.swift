//
//  Registry.swift
//  CodeEdit
//
//  Created by Abe Malla on 1/29/25.
//

import OSLog
import Foundation
import ZIPFoundation
import Combine

@MainActor
final class RegistryManager: ObservableObject {
    static let shared = RegistryManager()

    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: String(localized: "registry-manager.logger-category", defaultValue: "RegistryManager", comment: "Logger category for registry manager"))
    let installPath = Settings.shared.baseURL.appending(path: String(localized: "registry-manager.language-servers-path", defaultValue: "Language Servers", comment: "Directory name for language servers"))

    /// The URL of where the registry.json file will be downloaded from
    let registryURL = URL(
        string: String(localized: "registry-manager.registry-url", defaultValue: "https://github.com/mason-org/mason-registry/releases/latest/download/registry.json.zip", comment: "URL for registry JSON file")
    )!
    /// The URL of where the checksums.txt file will be downloaded from
    let checksumURL = URL(
        string: String(localized: "registry-manager.checksum-url", defaultValue: "https://github.com/mason-org/mason-registry/releases/latest/download/checksums.txt", comment: "URL for checksums file")
    )!

    @Published var isDownloadingRegistry: Bool = false
    /// Holds an errors found while downloading the registry file. Needs a UI to dismiss, is logged.
    @Published var downloadError: Error?
    /// Any currently running installation operation.
    @Published var runningInstall: PackageManagerInstallOperation?
    private var installTask: Task<Void, Never>?

    /// Indicates if the manager is currently installing a package.
    var isInstalling: Bool {
        installTask != nil
    }

    /// Reference to cached registry data. Will be removed from memory after a certain amount of time.
    private var cachedRegistry: CachedRegistry?
    /// Timer to clear expired cache
    private var cleanupTimer: Timer?
    /// Public access to registry items with cache management
    @Published public private(set) var registryItems: [RegistryItem] = []

    @AppSettings(\.languageServers.installedLanguageServers)
    var installedLanguageServers: [String: SettingsData.InstalledLanguageServer]

    init() {
        // Load the registry items from disk again after cache expires
        if let items = loadItemsFromDisk() {
            setRegistryItems(items)
        } else {
            Task {
                await downloadRegistryItems()
            }
        }
    }

    deinit {
        cleanupTimer?.invalidate()
    }

    // MARK: - Enable/Disable

    func setPackageEnabled(packageName: String, enabled: Bool) {
        installedLanguageServers[packageName]?.isEnabled = enabled
    }

    // MARK: - Uninstall

    @MainActor
    func removeLanguageServer(packageName: String) async throws {
        let packageName = packageName.removingPercentEncoding ?? packageName
        let packageDirectory = installPath.appending(path: packageName)

        guard FileManager.default.fileExists(atPath: packageDirectory.path) else {
            installedLanguageServers.removeValue(forKey: packageName)
            return
        }

        // Add to activity viewer
        NotificationCenter.default.post(
            name: .taskNotification,
            object: nil,
            userInfo: [
                String(localized: "registry-manager.notification-key.id", defaultValue: "id", comment: "Notification key for ID"): packageName,
                String(localized: "registry-manager.notification-key.action", defaultValue: "action", comment: "Notification key for action"): String(localized: "registry-manager.notification-action.create", defaultValue: "create", comment: "Notification action value for create"),
                String(localized: "registry-manager.notification-key.title", defaultValue: "title", comment: "Notification key for title"): String(format: String(localized: "registry-manager.removing-package", defaultValue: "Removing %@", comment: "Activity title for removing package"), packageName)
            ]
        )

        do {
            try await Task.detached(priority: .userInitiated) {
                try FileManager.default.removeItem(at: packageDirectory)
            }.value
            installedLanguageServers.removeValue(forKey: packageName)
        } catch {
            throw error
        }
    }

    // MARK: - Install

    public func installOperation(package: RegistryItem) throws -> PackageManagerInstallOperation {
        guard !isInstalling else {
            throw RegistryManagerError.installationRunning
        }
        guard let method = package.installMethod,
              let manager = method.packageManager(installPath: installPath) else {
            throw PackageManagerError.invalidConfiguration
        }
        let installSteps = try manager.install(method: method)
        return PackageManagerInstallOperation(package: package, steps: installSteps)
    }

    /// Starts the actual installation process for a package
    public func startInstallation(operation installOperation: PackageManagerInstallOperation) throws {
        guard !isInstalling else {
            throw RegistryManagerError.installationRunning
        }

        guard let method = installOperation.package.installMethod else {
            throw PackageManagerError.invalidConfiguration
        }

        // Run it!
        installPackage(operation: installOperation, method: method)
    }

    private func installPackage(operation: PackageManagerInstallOperation, method: InstallationMethod) {
        installTask = Task { [weak self] in
            defer {
                self?.installTask = nil
                self?.runningInstall = nil
            }
            self?.runningInstall = operation

            // Add to activity viewer
            let activityTitle = "\(operation.package.name)\("@" + (method.version ?? String(localized: "registry-manager.version.latest", defaultValue: "latest", comment: "Version label for latest version")))"
            TaskNotificationHandler.postTask(
                action: .create,
                model: TaskNotificationModel(id: operation.package.name, title: String(format: String(localized: "registry-manager.installing-package", defaultValue: "Installing %@", comment: "Activity title for installing package"), activityTitle))
            )

            guard !Task.isCancelled else { return }

            do {
                try await operation.run()
            } catch {
                self?.updateActivityViewer(operation.package.name, activityTitle, fail: true)
                return
            }

            self?.installedLanguageServers[operation.package.name] = .init(
                packageName: operation.package.name,
                isEnabled: true,
                version: method.version ?? ""
            )
            self?.updateActivityViewer(operation.package.name, activityTitle, fail: false)
        }
    }

    // MARK: - Cancel Install

    /// Cancel the currently running installation
    public func cancelInstallation() {
        runningInstall?.cancel()
        installTask?.cancel()
        installTask = nil
    }

    /// Updates the activity viewer with the status of the language server installation
    @MainActor
    private func updateActivityViewer(
        _ id: String,
        _ activityName: String,
        fail failed: Bool
    ) {
        if failed {
            NotificationManager.shared.post(
                iconSymbol: String(localized: "registry-manager.error-icon", defaultValue: "xmark.circle", comment: "SF Symbol name for error icon"),
                iconColor: .clear,
                title: String(format: String(localized: "registry-manager.install-failed", defaultValue: "Could not install %@", comment: "Notification title for failed installation"), activityName),
                description: String(localized: "registry-manager.install-problem", defaultValue: "There was a problem during installation.", comment: "Notification description for installation problem"),
                actionButtonTitle: String(localized: "registry-manager.done", defaultValue: "Done", comment: "Button label for done action"),
                action: {},
            )
        } else {
            TaskNotificationHandler.postTask(
                action: .update,
                model: TaskNotificationModel(id: id, title: String(format: String(localized: "registry-manager.install-success", defaultValue: "Successfully installed %@", comment: "Activity title for successful installation"), activityName), isLoading: false)
            )
            NotificationCenter.default.post(
                name: .taskNotification,
                object: nil,
                userInfo: [
                    String(localized: "registry-manager.notification-key.id", defaultValue: "id", comment: "Notification key for ID"): id,
                    String(localized: "registry-manager.notification-key.action", defaultValue: "action", comment: "Notification key for action"): String(localized: "registry-manager.notification-action.delete-with-delay", defaultValue: "deleteWithDelay", comment: "Notification action value for delete with delay"),
                    String(localized: "registry-manager.notification-key.delay", defaultValue: "delay", comment: "Notification key for delay"): 5.0,
                ]
            )
        }
    }

    // MARK: - Cache

    func setRegistryItems(_ items: [RegistryItem]) {
        cachedRegistry = CachedRegistry(items: items)

        // Set up timer to clear the cache after expiration
        cleanupTimer?.invalidate()
        cleanupTimer = Timer.scheduledTimer(
            withTimeInterval: CachedRegistry.expirationInterval, repeats: false
        ) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                self.cachedRegistry = nil
                self.cleanupTimer = nil
                await self.downloadRegistryItems()
            }
        }

        registryItems = items
    }
}

/// `CachedRegistry` is a timer based cache that will remove the registry items from memory
/// after a certain amount of time. This is because this memory is not needed for the majority of the
/// lifetime of the application and can be freed when no longer used.
private final class CachedRegistry {
    let items: [RegistryItem]
    let timestamp: Date

    static let expirationInterval: TimeInterval = 300 // 5 minutes

    init(items: [RegistryItem]) {
        self.items = items
        self.timestamp = Date()
    }

    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > Self.expirationInterval
    }
}
