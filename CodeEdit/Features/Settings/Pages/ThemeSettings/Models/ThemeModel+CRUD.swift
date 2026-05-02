//
//  ThemeModel+CRUD.swift
//  CodeEdit
//
//  Created by Austin Condiff on 6/18/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension ThemeModel {
    /// Loads a theme from a given url and appends it to ``themes``.
    /// - Parameter url: The URL of the theme
    /// - Returns: A ``Theme``
    private func load(from url: URL) throws -> Theme? {
        do {
            // get the data from the provided file
            let json = try Data(contentsOf: url)
            // decode the json into ``Theme``
            let theme = try JSONDecoder().decode(Theme.self, from: json)
            return theme
        } catch {
            print(error)
            return nil
        }
    }

    /// Loads all available themes from `~/Library/Application Support/CodeEdit/Themes/`
    ///
    /// If no themes are available, it will create a default theme and save
    /// it to the location mentioned above.
    ///
    /// When overrides are found in `~/Library/Application Support/CodeEdit/settings.json`
    /// they are applied to the loaded themes without altering the original
    /// the files in `~/Library/Application Support/CodeEdit/Themes/`.
    func loadThemes() throws { // swiftlint:disable:this function_body_length
        if let bundledThemesURL = bundledThemesURL {
            // remove all themes from memory
            themes.removeAll()

            var isDir: ObjCBool = false

            // check if a themes directory exists, otherwise create one
            if !filemanager.fileExists(atPath: themesURL.path, isDirectory: &isDir) {
                try filemanager.createDirectory(at: themesURL, withIntermediateDirectories: true)
            }

            // get all URLs in users themes folder that end with `.cetheme`
            let userDefinedThemeFilenames = try filemanager.contentsOfDirectory(atPath: themesURL.path).filter {
                $0.contains(String(localized: "theme.crud.file.extension.filter", defaultValue: ".cetheme", comment: "Theme file extension for filtering"))
            }
            let userDefinedThemeURLs = userDefinedThemeFilenames.map {
                themesURL.appending(path: $0)
            }

            // get all bundled theme URLs
            let bundledThemeFilenames = try filemanager.contentsOfDirectory(atPath: bundledThemesURL.path).filter {
                $0.contains(String(localized: "theme.crud.file.extension.filter.bundled", defaultValue: ".cetheme", comment: "Theme file extension for filtering bundled themes"))
            }
            let bundledThemeURLs = bundledThemeFilenames.map {
                bundledThemesURL.appending(path: $0)
            }

            // combine user theme URLs with bundled theme URLs
            let themeURLs = userDefinedThemeURLs + bundledThemeURLs

            let prefs = Settings.shared.preferences

            // load each theme from disk and store in memory
            try themeURLs.forEach { fileURL in
                if var theme = try load(from: fileURL) {

                    // get all properties of terminal and editor colors
                    guard let terminalColors = try theme.terminal.allProperties() as? [String: Theme.Attributes],
                          let editorColors = try theme.editor.allProperties() as? [String: Theme.Attributes]
                    else {
                        print(String(localized: "theme.crud.error.properties", defaultValue: "error", comment: "Error message when theme properties cannot be loaded"))
                        // TODO: Throw a proper error
                        throw NSError() // swiftlint:disable:this discouraged_direct_init
                    }

                    // check if there are any overrides in `settings.json`
                    if let overrides = prefs.theme.overrides[theme.name]?[String(localized: "theme.crud.override.key.terminal", defaultValue: "terminal", comment: "Theme override key for terminal colors")] {
                        terminalColors.forEach { (key, _) in
                            if let attributes = overrides[key] {
                                theme.terminal[key] = attributes
                            }
                        }
                    }

                    if let overrides = prefs.theme.overrides[theme.name]?[String(localized: "theme.crud.override.key.editor", defaultValue: "editor", comment: "Theme override key for editor colors")] {
                        editorColors.forEach { (key, _) in
                            if let attributes = overrides[key] {
                                theme.editor[key] = attributes
                            }
                        }
                    }

                    theme.isBundled = fileURL.path.contains(bundledThemesURL.path)

                    theme.fileURL = fileURL

                    // add the theme to themes array
                    self.themes.append(theme)

                    // if there already is a selected theme in `settings.json` select this theme
                    // otherwise take the first in the list
                    self.selectedDarkTheme = self.darkThemes.first {
                        $0.name == prefs.theme.selectedDarkTheme
                    } ?? self.darkThemes.first

                    self.selectedLightTheme = self.lightThemes.first {
                        $0.name == prefs.theme.selectedLightTheme
                    } ?? self.lightThemes.first

                    // For selecting the default theme, doing it correctly on startup requires some more logic
                    let userSelectedTheme = self.themes.first { $0.name == prefs.theme.selectedTheme }
                    let systemAppearance = NSAppearance.currentDrawing().name

                    if userSelectedTheme != nil {
                        self.selectedTheme = userSelectedTheme
                    } else {
                        if systemAppearance == .darkAqua {
                            self.selectedTheme = self.selectedDarkTheme
                        } else {
                            self.selectedTheme = self.selectedLightTheme
                        }
                    }
                }
            }
        }
    }

    func importTheme() {
        let openPanel = NSOpenPanel()
        let allowedTypes = [UTType(filenameExtension: String(localized: "theme.crud.import.file.extension", defaultValue: "cetheme", comment: "Theme file extension for import"))!]

        openPanel.prompt = String(localized: "theme.crud.import.prompt", defaultValue: "Import", comment: "Import button prompt in open panel")
        openPanel.allowedContentTypes = allowedTypes
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false

        openPanel.begin { result in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let url = openPanel.urls.first {
                    self.duplicate(url)
                }
            }
        }
    }

    func duplicate(_ url: URL) {
        do {
            self.isAdding = true
            // Construct the destination file URL
            var destinationFileURL = self.themesURL.appending(path: url.lastPathComponent)

            // Extract the base filename and extension
            let fileExtension = destinationFileURL.pathExtension

            var fileName = destinationFileURL.deletingPathExtension().lastPathComponent
            var newFileName = fileName

            var iterator = 1

            let isBundled = url.absoluteString.hasPrefix(bundledThemesURL?.absoluteString ?? "")
            let isImporting =
                !url.absoluteString.hasPrefix(bundledThemesURL?.absoluteString ?? "")
                && !url.absoluteString.hasPrefix(themesURL.absoluteString)

            if isBundled {
                newFileName = String(format: String(localized: "theme.crud.duplicate.filename.format", defaultValue: "%@ %d", comment: "Format for duplicated theme filename"), fileName, iterator)
                destinationFileURL = self.themesURL
                    .appending(path: newFileName)
                    .appendingPathExtension(fileExtension)
            }

            // Check if the file already exists
            while FileManager.default.fileExists(atPath: destinationFileURL.path) {
                fileName = destinationFileURL.deletingPathExtension().lastPathComponent

                // Remove any existing iterator
                if let range = fileName.range(of: " \\d+$", options: .regularExpression) {
                    fileName = String(fileName[..<range.lowerBound])
                }

                // Generate a new filename with an iterator
                newFileName = String(format: String(localized: "theme.crud.duplicate.filename.format.iterator", defaultValue: "%@ %d", comment: "Format for duplicated theme filename with iterator"), fileName, iterator)
                destinationFileURL = self.themesURL
                    .appending(path: newFileName)
                    .appendingPathExtension(fileExtension)

                iterator += 1
            }

            // Copy the file from selected URL to the destination
            try FileManager.default.copyItem(at: url, to: destinationFileURL)

            try self.loadThemes()

            if let index = self.themes.firstIndex(where: { $0.fileURL == destinationFileURL }) {
                self.themes[index].displayName = newFileName
                self.themes[index].name = newFileName.lowercased().replacingOccurrences(of: String(localized: "theme.crud.duplicate.name.space.replacement", defaultValue: " ", comment: "Space character to replace in theme name"), with: String(localized: "theme.crud.duplicate.name.space.replacement.with", defaultValue: "-", comment: "Dash character to replace spaces with in theme name"))

                if isImporting != true {
                    self.themes[index].author = NSFullUserName()
                    self.save(self.themes[index])
                }

                self.previousTheme = self.selectedTheme

                activateTheme(self.themes[index])

                self.detailsTheme = self.themes[index]
                self.detailsIsPresented = true
            }
        } catch {
            print(String(format: String(localized: "theme.crud.error.adding.theme", defaultValue: "Error adding theme: %@", comment: "Error message when adding theme fails"), error.localizedDescription))
        }
    }

    func rename(to newName: String, theme: Theme) {
        do {
            guard let oldURL = theme.fileURL else {
                throw NSError(
                    domain: String(localized: "theme.crud.error.domain", defaultValue: "ThemeModel", comment: "Error domain for theme model errors"),
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: String(localized: "theme.crud.error.rename.url.not.found", defaultValue: "Theme file URL not found", comment: "Error message when theme file URL is not found for rename")]
                )
            }

            var finalName = newName
            var finalURL = themesURL.appending(path: finalName).appendingPathExtension(String(localized: "theme.crud.rename.file.extension", defaultValue: "cetheme", comment: "Theme file extension for rename"))
            var iterator = 1

            // Check for existing display names in themes
            while themes.contains(where: { theme != $0 && $0.displayName == finalName }) {
                finalName = String(format: String(localized: "theme.crud.rename.filename.format", defaultValue: "%@ %d", comment: "Format for renamed theme filename with iterator"), newName, iterator)
                finalURL = themesURL.appending(path: finalName).appendingPathExtension(String(localized: "theme.crud.rename.file.extension.iterator", defaultValue: "cetheme", comment: "Theme file extension for rename with iterator"))
                iterator += 1
            }

            _ = self.getThemeActive(theme)

            try filemanager.moveItem(at: oldURL, to: finalURL)

            try self.loadThemes()
        } catch {
            print(String(format: String(localized: "theme.crud.error.renaming.theme", defaultValue: "Error renaming theme: %@", comment: "Error message when renaming theme fails"), error.localizedDescription))
        }
    }

    /// Save theme to file
    func save(_ theme: Theme) {
        do {
            if let fileURL = theme.fileURL {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.sortedKeys]
                let data = try encoder.encode(theme)
                let json = try JSONSerialization.jsonObject(with: data)
                let prettyJSON = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
                try prettyJSON.write(to: fileURL, options: .atomic)
            }
        } catch {
            print(String(format: String(localized: "theme.crud.error.saving.theme", defaultValue: "Error saving theme: %@", comment: "Error message when saving theme fails"), error.localizedDescription))
        }
    }

    /// Removes the given theme from `–/Library/Application Support/CodeEdit/themes`
    ///
    /// After removing the theme, themes are reloaded
    /// from `~/Library/Application Support/CodeEdit/Themes`. See ``loadThemes()``
    /// for more information.
    ///
    /// - Parameter theme: The theme to delete
    func delete(_ theme: Theme) {
        if let url = theme.fileURL {
            do {
                try filemanager.removeItem(at: url)

                Settings.shared.preferences.theme.overrides.removeValue(forKey: theme.name)

                try self.loadThemes()
            } catch {
                print(error)
            }
        }
    }
}
