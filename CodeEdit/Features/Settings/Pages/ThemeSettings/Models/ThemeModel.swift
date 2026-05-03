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
        filemanager.homeDirectoryForCurrentUser.appending(path: String(localized: "theme.folder.application_support_path", defaultValue: "Library/Application Support/CodeEdit", comment: "Path to CodeEdit application support folder"))
    }

    var bundledThemesURL: URL? {
        Bundle.main.resourceURL?.appending(path: String(localized: "theme.folder.default_themes", defaultValue: "DefaultThemes", comment: "Folder name for bundled default themes"), directoryHint: .isDirectory) ?? nil
    }

    /// The URL of the `Themes` folder
    internal var themesURL: URL {
        baseURL.appending(path: String(localized: "theme.folder.themes", defaultValue: "Themes", comment: "Folder name for themes"), directoryHint: .isDirectory)
    }

    /// The URL of the `Extensions` folder
    internal var extensionsURL: URL {
        baseURL.appending(path: String(localized: "theme.folder.extensions", defaultValue: "Extensions", comment: "Folder name for extensions"), directoryHint: .isDirectory)
    }

    /// The URL of the `settings.json` file
    internal var settingsURL: URL {
        baseURL.appending(path: String(localized: "theme.file.settings_json", defaultValue: "settings.json", comment: "Filename for settings JSON file"), directoryHint: .isDirectory)
    }

    /// System color scheme
    @Published var colorScheme: ColorScheme = .light

    /// Selected 'light' theme
    /// Used for auto-switching theme to match macOS system appearance
    @Published var selectedLightTheme: Theme? {
        didSet {
            DispatchQueue.main.async {
                Settings.shared
                    .preferences.theme.selectedLightTheme = self.selectedLightTheme?.name ?? String(localized: "theme.status.broken", defaultValue: "Broken", comment: "Status label for broken theme")
            }
        }
    }

    /// Selected 'dark' theme
    /// Used for auto-switching theme to match macOS system appearance
    @Published var selectedDarkTheme: Theme? {
        didSet {
            DispatchQueue.main.async {
                Settings.shared
                    .preferences.theme.selectedDarkTheme = self.selectedDarkTheme?.name ?? String(localized: "theme.status.broken", defaultValue: "Broken", comment: "Status label for broken theme")
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
                return String(localized: "theme.appearance.light", defaultValue: "Light Appearance", comment: "Light appearance theme setting")
            case .dark:
                return String(localized: "theme.appearance.dark", defaultValue: "Dark Appearance", comment: "Dark appearance theme setting")
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
            print(String(localized: "theme.export.error.url_not_found", defaultValue: "Theme file URL not found.", comment: "Error message when theme file URL is not found"))
            return
        }

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType(filenameExtension: String(localized: "theme.file.extension.cetheme", defaultValue: "cetheme", comment: "CodeEdit theme file extension"))!]
        savePanel.nameFieldStringValue = theme.displayName
        savePanel.prompt = String(localized: "theme.export.prompt", defaultValue: "Export", comment: "Save panel prompt for exporting theme")
        savePanel.canCreateDirectories = true

        savePanel.begin { response in
            if response == .OK, let destinationURL = savePanel.url {
                do {
                    try FileManager.default.copyItem(at: themeFileURL, to: destinationURL)
                    print(String(format: String(localized: "theme.export.success", defaultValue: "Theme exported successfully to %@", comment: "Success message when theme is exported (path)"), destinationURL.path))
                } catch {
                    print(String(format: String(localized: "theme.export.error.failed", defaultValue: "Failed to export theme: %@", comment: "Error message when theme export fails (error description)"), error.localizedDescription))
                }
            }
        }
    }

    func exportAllCustomThemes() {
            let openPanel = NSOpenPanel()
            openPanel.prompt = String(localized: "theme.export.prompt", defaultValue: "Export", comment: "Save panel prompt for exporting theme")
            openPanel.canChooseFiles = false
            openPanel.canChooseDirectories = true
            openPanel.allowsMultipleSelection = false

            openPanel.begin { result in
                if result == .OK, let exportDirectory = openPanel.url {
                    let customThemes = self.themes.filter { !$0.isBundled }

                    for theme in customThemes {
                        guard let sourceURL = theme.fileURL else { continue }

                        let destinationURL = exportDirectory.appending(path: String(format: String(localized: "theme.export.filename_format", defaultValue: "%@.cetheme", comment: "Filename format for exported theme (theme name)"), theme.displayName))

                        do {
                            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                            print(String(format: String(localized: "theme.export.all.success", defaultValue: "Exported %@ to %@", comment: "Success message when exporting a theme (theme name, path)"), theme.displayName, destinationURL.path))
                        } catch {
                            print(String(format: String(localized: "theme.export.all.error.failed", defaultValue: "Failed to export %@: %@", comment: "Error message when exporting a theme fails (theme name, error description)"), theme.displayName, error.localizedDescription))
                        }
                    }
                }
            }
        }
}
