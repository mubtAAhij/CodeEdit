//
//  SoftwareUpdater.swift
//  CodeEdit
//
//  Created by Austin Condiff on 9/19/22.
//

import Foundation
import Sparkle

class SoftwareUpdater: NSObject, ObservableObject, SPUUpdaterDelegate {
    private var updater: SPUUpdater?
    private var automaticallyChecksForUpdatesObservation: NSKeyValueObservation?
    private var lastUpdateCheckDateObservation: NSKeyValueObservation?
    private var appcastURL = URL(
        string: String(localized: "updater.appcast_url", defaultValue: "https://github.com/CodeEditApp/CodeEdit/releases/download/latest/appcast.xml", comment: "Default appcast URL")
    )!

    @Published var automaticallyChecksForUpdates = false {
        didSet {
            updater?.automaticallyChecksForUpdates = automaticallyChecksForUpdates
        }
    }

    @Published var lastUpdateCheckDate: Date?

    @Published var includePrereleaseVersions = true {
        didSet {
            UserDefaults.standard.setValue(includePrereleaseVersions, forKey: String(localized: "updater.prerelease_key", defaultValue: "includePrereleaseVersions", comment: "UserDefaults key for prerelease versions"))
        }
    }

    private var feedURLTask: Task<(), Never>?

    private func setFeedURL() async {
        let url = URL(string: String(localized: "updater.github_api_url", defaultValue: "https://api.github.com/repos/CodeEditApp/CodeEdit/releases/latest", comment: "GitHub API URL for latest release"))!
        let request = URLRequest(url: url)
        guard let data = try? await URLSession.shared.data(for: request),
              let result = try? JSONDecoder().decode(GHAPIResult.self, from: data.0) else {
            await MainActor.run {
                self.updater?.setFeedURL(nil)
            }
            return
        }
        await MainActor.run {
            appcastURL = URL(
                string: "https://github.com/CodeEditApp/CodeEdit/releases/download/\(result.tagName)/appcast.xml"
            )!
            self.updater?.setFeedURL(appcastURL)
        }
    }

    override init() {
        super.init()
        updater = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: self,
            userDriverDelegate: nil
        ).updater

        feedURLTask = Task {
            await setFeedURL()
        }

        automaticallyChecksForUpdatesObservation = updater?.observe(
            \.automaticallyChecksForUpdates,
            options: [.initial, .new, .old],
            changeHandler: { [unowned self] updater, change in
                guard change.newValue != change.oldValue else { return }
                self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
            }
        )

        lastUpdateCheckDateObservation = updater?.observe(
            \.lastUpdateCheckDate,
            options: [.initial, .new, .old],
            changeHandler: { [unowned self] updater, _ in
                self.lastUpdateCheckDate = updater.lastUpdateCheckDate
            }
        )

        includePrereleaseVersions = UserDefaults.standard.bool(forKey: String(localized: "updater.prerelease_key", defaultValue: "includePrereleaseVersions", comment: "UserDefaults key for prerelease versions"))
    }

    deinit {
        feedURLTask?.cancel()
    }

    func allowedChannels(for updater: SPUUpdater) -> Set<String> {
        // TODO: Uncomment when production build is released. 
        // if includePrereleaseVersions {
        return [String(localized: "updater.dev_channel", defaultValue: "dev", comment: "Development update channel")]
        // }
        // return []
    }

    func checkForUpdates() {
        updater?.checkForUpdates()
    }

    private struct GHAPIResult: Codable {
        enum CodingKeys: String, CodingKey {
            case tagName = String(localized: "updater.tag_name_field", defaultValue: "tag_name", comment: "GitHub API tag_name field")
        }

        var tagName: String
    }
}
