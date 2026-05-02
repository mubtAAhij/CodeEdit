//
//  ThemeModel.swift
//  CodeEditModules/Settings
//
//  Created by Lukas Pistrol on 31.03.22.
//

import SwiftUI
import UniformTypeIdentifiers

/// The Theme View Model. Accessible via the singleton "``ThemeModel/shared``".
///
/// **Usage:**
/// ```swift
/// @StateObject
/// private var themeModel: ThemeModel = .shared
/// ```
final class ThemeModel: ObservableObject {
    static let shared: ThemeModel = .init()

    @AppSettings(\.theme)
    var settings

    /// Default instance of the `FileManager`
    let filemanager = FileManager.default

    /// The base folder url `~/Library/Application Support/CodeEdit/`
    private var baseURL: URL {
        filemanager.homeDirectoryForCurrentUser.appending(path: String(localized: "theme.path.app-support", defaultValue: "Library/Application Support/CodeEdit", comment: "Application support path for CodeEdit"))
    }

    var bundledThemesURL: URL? {
        Bundle.main.resourceURL?.appending(path: String(localized: "theme.path.default-themes", defaultValue: "DefaultThemes", comment: "Default themes folder name"), directoryHint: .isDirectory) ?? nil
    }

    /// The URL of the `Themes` folder
    internal var themesURL: URL {
        baseURL.appending(path: String(localized: "theme.path.themes", defaultValue: "Themes", comment: "Themes folder name"), directoryHint: .isDirectory)
    }

    /// The URL of the `Extensions` folder
    internal var extensionsURL: URL {
        baseURL.appending(path: String(localized: "theme.path.extensions", defaultValue: "Extensions", comment: "Extensions folder name"), directoryHint: .isDirectory)
    }

    /// The URL of the `settings.json` file
    internal var settingsURL: URL {
        baseURL.appending(path: String(localized: "theme.path.settings-file", defaultValue: "settings.json", comment: "Settings file name"), directoryHint: .isDirectory)
    }

    /// System color scheme
    @Published var colorScheme: ColorScheme = .light

    /// Selected 'light' theme
    /// Used for auto-switching theme to match macOS system appearance
    @Published var selectedLightTheme: Theme? {
        didSet {
            DispatchQueue.main.async {
                Settings.shared
                    .preferences.theme.selectedLightTheme = self.selectedLightTheme?.name ?? String(localized: "theme.broken", defaultValue: "Broken", comment: "Placeholder for broken theme name")
            }
        }
    }

    /// Selected 'dark' theme
    /// Used for auto-switching theme to match macOS system appearance
    @Published var selectedDarkTheme: Theme? {
        didSet {
            DispatchQueue.main.async {
                Settings.shared
                    .preferences.theme.selectedDarkTheme = self.selectedDarkTheme?.name ?? String(localized: "theme.broken", defaultValue: "Broken", comment: "Placeholder for broken theme name")
            }
        }
    }

    @Published var detailsIsPresented: Bool = false

    @Published var isAdding: Bool = false

    @Published var detailsTheme: Theme?

    /// An array of loaded ``Theme``.
    @Published var themes: [Theme] = []

    /// The currently selected ``Theme``.
    @Published var selectedTheme: Theme? {
        didSet {
            DispatchQueue.main.async {
                Settings[\.theme].selectedTheme = self.selectedTheme?.name
            }
        }
    }

    @Published var previousTheme: Theme?

    /// Only themes where ``Theme/appearance`` == ``Theme/ThemeType/dark``
    var darkThemes: [Theme] {
        themes.filter { $0.appearance == .dark }
    }

    /// Only themes where ``Theme/appearance`` == ``Theme/ThemeType/light``
    var lightThemes: [Theme] {
        themes.filter { $0.appearance == .light }
    }

    private init() {
        do {
            try loadThemes()
        } catch {
            print(error)
        }
    }

    /// This function stores  'dark' and 'light' themes into `ThemePreferences` if user happens to select a theme
    func updateAppearanceTheme() {
        if self.selectedTheme?.appearance == .dark {
            self.selectedDarkTheme = self.selectedTheme
        } else if self.selectedTheme?.appearance == .light {
            self.selectedLightTheme = self.selectedTheme
        }
    }

    func cancelDetails(_ theme: Theme) {
        if let index = themes.firstIndex(where: { $0.fileURL == theme.fileURL }),
        let detailsTheme = self.detailsTheme {
            self.themes[index] = detailsTheme
            self.save(self.themes[index])
        }
    }

    /// Initialize to the app's current appearance.
    var selectedAppearance: ThemeSettingsAppearances {
        NSApp.effectiveAppearance.name == .darkAqua ? .dark : .light
    }

    enum ThemeSettingsAppearances: String, CaseIterable {
        case light = "Light Appearance"
        case dark = "Dark Appearance"

        var displayName: String {
            switch self {
            case .light:
                return String(localized: "theme.appearance.light", defaultValue: "Light Appearance", comment: "Light appearance label")
            case .dark:
                return String(localized: "theme.appearance.dark", defaultValue: "Dark Appearance", comment: "Dark appearance label")
            }
        }
    }

    func getThemeActive(_ theme: Theme) -> Bool {
        return selectedTheme == theme
    }

    /// Activates the current theme, setting ``selectedTheme`` and ``selectedLightTheme``/``selectedDarkTheme`` as
    /// necessary.
    /// - Parameter theme: The theme to activate.
    func activateTheme(_ theme: Theme) {
        selectedTheme = theme
        if colorScheme == .light {
            selectedLightTheme = theme
        }
        if colorScheme == .dark {
            selectedDarkTheme = theme
        }
    }

    func exportTheme(_ theme: Theme) {
        guard let themeFileURL = theme.fileURL else {
            print(String(localized: "theme.export.error.no-url", defaultValue: "Theme file URL not found.", comment: "Error when theme file URL is missing"))
            return
        }

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType(filenameExtension: String(localized: "theme.file-extension", defaultValue: "cetheme", comment: "CodeEdit theme file extension"))!]
        savePanel.nameFieldStringValue = theme.displayName
        savePanel.prompt = String(localized: "theme.export.prompt", defaultValue: "Export", comment: "Export panel prompt")
        savePanel.canCreateDirectories = true

        savePanel.begin { response in
            if response == .OK, let destinationURL = savePanel.url {
                do {
                    try FileManager.default.copyItem(at: themeFileURL, to: destinationURL)
                    print(String(format: String(localized: "theme.export.success", defaultValue: "Theme exported successfully to %@", comment: "Success message for theme export"), destinationURL.path))
                } catch {
                    print(String(format: String(localized: "theme.export.error.failed", defaultValue: "Failed to export theme: %@", comment: "Error message for failed theme export"), error.localizedDescription))
                }
            }
        }
    }

    func exportAllCustomThemes() {
            let openPanel = NSOpenPanel()
            openPanel.prompt = String(localized: "theme.export-all.prompt", defaultValue: "Export", comment: "Export all panel prompt")
            openPanel.canChooseFiles = false
            openPanel.canChooseDirectories = true
            openPanel.allowsMultipleSelection = false

            openPanel.begin { result in
                if result == .OK, let exportDirectory = openPanel.url {
                    let customThemes = self.themes.filter { !$0.isBundled }

                    for theme in customThemes {
                        guard let sourceURL = theme.fileURL else { continue }

                        let destinationURL = exportDirectory.appending(path: String(format: String(localized: "theme.export.filename", defaultValue: "%@.cetheme", comment: "Theme export filename format"), theme.displayName))

                        do {
                            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                            print(String(format: String(localized: "theme.export-all.success", defaultValue: "Exported %@ to %@", comment: "Success message for exporting individual theme"), theme.displayName, destinationURL.path))
                        } catch {
                            print(String(format: String(localized: "theme.export-all.error.failed", defaultValue: "Failed to export %@: %@", comment: "Error message for failed individual theme export"), theme.displayName, error.localizedDescription))
                        }
                    }
                }
            }
        }
}
