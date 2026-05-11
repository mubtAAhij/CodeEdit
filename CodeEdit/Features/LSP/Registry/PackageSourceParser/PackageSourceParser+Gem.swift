//
//  PackageSourceParser+Gem.swift
//  CodeEdit
//
//  Created by Abe Malla on 3/12/25.
//

extension PackageSourceParser {
    static func parseRubyGem(_ entry: RegistryItem) -> InstallationMethod {
        // Format: pkg:gem/PACKAGE@VERSION?PARAMS
        let pkgPrefix = String(localized: "package-source-parser.gem-prefix", defaultValue: "pkg:gem/", comment: "Gem package URL scheme prefix")
        let sourceId = entry.source.id.removingPercentEncoding ?? entry.source.id
        guard sourceId.hasPrefix(pkgPrefix) else { return .unknown }

        let pkgString = sourceId.dropFirst(pkgPrefix.count)

        let components = pkgString.split(separator: String(localized: "package-source-parser.query-separator", defaultValue: "?", comment: "URL query parameter separator"), maxSplits: 1)
        let packageVersion = String(components[0])
        let parameters = components.count > 1 ? String(components[1]) : ""

        let packageVersionParts = packageVersion.split(separator: String(localized: "package-source-parser.version-separator", defaultValue: "@", comment: "Package version separator"), maxSplits: 1)
        guard packageVersionParts.count >= 1 else { return .unknown }

        let packageName = String(packageVersionParts[0])
        let version = packageVersionParts.count > 1 ? String(packageVersionParts[1]) : String(localized: "package-source-parser.latest-version", defaultValue: "latest", comment: "Default latest version identifier")

        // Parse parameters as options
        var options: [String: String] = [String(localized: "package-source-parser.build-tool-key", defaultValue: "buildTool", comment: "Build tool parameter key"): String(localized: "package-source-parser.gem-value", defaultValue: "gem", comment: "Gem package manager identifier")]
        var repositoryUrl: String?
        var gitReference: PackageSource.GitReference?

        let paramPairs = parameters.split(separator: String(localized: "package-source-parser.param-separator", defaultValue: "&", comment: "Parameter separator character"))
        for pair in paramPairs {
            let keyValue = pair.split(separator: String(localized: "package-source-parser.key-value-separator", defaultValue: "=", comment: "Key-value separator character"), maxSplits: 1)
            guard keyValue.count == 2 else { continue }

            let key = String(keyValue[0])
            let value = String(keyValue[1])

            if key == String(localized: "package-source-parser.repository-url-key", defaultValue: "repository_url", comment: "Repository URL parameter key") {
                repositoryUrl = value
            } else if key == String(localized: "package-source-parser.rev-key", defaultValue: "rev", comment: "Revision parameter key") && value.lowercased() == String(localized: "package-source-parser.true-value", defaultValue: "true", comment: "Boolean true value") {
                gitReference = .revision(version)
            } else if key == String(localized: "package-source-parser.tag-key", defaultValue: "tag", comment: "Tag parameter key") && value.lowercased() == String(localized: "package-source-parser.true-value", defaultValue: "true", comment: "Boolean true value") {
                gitReference = .tag(version)
            } else {
                options[key] = value
            }
        }

        let source = PackageSource(
            sourceId: sourceId,
            type: .gem,
            pkgName: packageName,
            entryName: entry.name,
            version: version,
            repositoryUrl: repositoryUrl,
            gitReference: gitReference,
            options: options
        )
        return .standardPackage(source: source)
    }
}
