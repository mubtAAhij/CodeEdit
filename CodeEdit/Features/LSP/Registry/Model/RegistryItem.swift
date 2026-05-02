//
//  RegistryItem.swift
//  CodeEdit
//
//  Created by Abe Malla on 1/29/25.
//

import Foundation

/// A `RegistryItem` represents an entry in the Registry that saves language servers, DAPs, linters and formatters.
struct RegistryItem: Codable {
    let name: String
    let description: String
    let homepage: String
    let licenses: [String]
    let languages: [String]
    let categories: [String]
    let source: Source
    let bin: [String: String]?

    var sanitizedName: String {
        name.replacingOccurrences(of: String(localized: "registry.item.separator.hyphen", defaultValue: "-", comment: "Registry item hyphen separator"), with: " ")
            .replacingOccurrences(of: String(localized: "registry.item.separator.underscore", defaultValue: "_", comment: "Registry item underscore separator"), with: " ")
            .split(separator: " ")
            .map { word -> String in
                let str = String(word).lowercased()
                // Check for special cases
                if str == String(localized: "registry.item.abbrev.ls", defaultValue: "ls", comment: "Registry item ls abbreviation") || str == String(localized: "registry.item.abbrev.lsp", defaultValue: "lsp", comment: "Registry item lsp abbreviation") || str == String(localized: "registry.item.abbrev.ci", defaultValue: "ci", comment: "Registry item ci abbreviation") || str == String(localized: "registry.item.abbrev.cli", defaultValue: "cli", comment: "Registry item cli abbreviation") {
                    return str.uppercased()
                }
                return str.capitalized
            }
            .joined(separator: " ")
    }

    var sanitizedDescription: String {
        description.replacingOccurrences(of: "\n", with: " ")
    }

    var homepageURL: URL? {
        URL(string: homepage)
    }

    /// A pretty version of the homepage URL.
    /// Removes the schema (eg https) and leaves the path and domain.
    var homepagePretty: String {
        guard let homepageURL else { return homepage }
        return (homepageURL.host(percentEncoded: false) ?? "") + homepageURL.path(percentEncoded: false)
    }

    /// The method for installation, parsed from this item's ``source-swift.property`` parameter.
    var installMethod: InstallationMethod? {
        let sourceId = source.id
        if sourceId.hasPrefix(String(localized: "registry.item.pkg.cargo", defaultValue: "pkg:cargo/", comment: "Registry item Cargo package prefix")) {
            return PackageSourceParser.parseCargoPackage(self)
        } else if sourceId.hasPrefix(String(localized: "registry.item.pkg.npm", defaultValue: "pkg:npm/", comment: "Registry item NPM package prefix")) {
            return PackageSourceParser.parseNpmPackage(self)
        } else if sourceId.hasPrefix(String(localized: "registry.item.pkg.pypi", defaultValue: "pkg:pypi/", comment: "Registry item PyPI package prefix")) {
            return PackageSourceParser.parsePythonPackage(self)
        } else if sourceId.hasPrefix(String(localized: "registry.item.pkg.gem", defaultValue: "pkg:gem/", comment: "Registry item Gem package prefix")) {
            return PackageSourceParser.parseRubyGem(self)
        } else if sourceId.hasPrefix(String(localized: "registry.item.pkg.golang", defaultValue: "pkg:golang/", comment: "Registry item Golang package prefix")) {
            return PackageSourceParser.parseGolangPackage(self)
        } else if sourceId.hasPrefix(String(localized: "registry.item.pkg.github", defaultValue: "pkg:github/", comment: "Registry item GitHub package prefix")) {
            return PackageSourceParser.parseGithubPackage(self)
        } else {
            return nil
        }
    }

    /// Serializes back to JSON format
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        guard let dictionary = jsonObject as? [String: Any] else {
            throw NSError(domain: String(localized: "registry.item.conversion.error", defaultValue: "ConversionError", comment: "Registry item conversion error domain"), code: 1)
        }
        return dictionary
    }
}

extension RegistryItem: FuzzySearchable {
    var searchableString: String { name }
}
