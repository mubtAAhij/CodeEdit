//
//  PackageSourceParser+NPM.swift
//  CodeEdit
//
//  Created by Abe Malla on 3/12/25.
//

extension PackageSourceParser {
    static func parseNpmPackage(_ entry: RegistryItem) -> InstallationMethod {
        // Format: pkg:npm/PACKAGE@VERSION?PARAMS
        let pkgPrefix = String(localized: "npm.package.prefix", defaultValue: "pkg:npm/", comment: "NPM package URL prefix for package parsing")
        let sourceId = entry.source.id.removingPercentEncoding ?? entry.source.id
        guard sourceId.hasPrefix(pkgPrefix) else { return .unknown }

        let pkgString = sourceId.dropFirst(pkgPrefix.count)

        // Split into package@version and parameters
        let components = pkgString.split(separator: Character(String(localized: "npm.separator.question", defaultValue: "?", comment: "Question mark separator for URL parameters in NPM package URL")), maxSplits: 1)
        let packageVersion = String(components[0])
        let parameters = components.count > 1 ? String(components[1]) : ""

        let (packageName, version) = parseNPMPackageNameAndVersion(packageVersion)

        // Parse parameters as options
        var options: [String: String] = [String(localized: "npm.option.build.tool", defaultValue: "buildTool", comment: "NPM package option key for build tool"): String(localized: "npm.tool.name", defaultValue: "npm", comment: "NPM tool name identifier")]
        var repositoryUrl: String?
        var gitReference: PackageSource.GitReference?

        let paramPairs = parameters.split(separator: Character(String(localized: "npm.separator.ampersand", defaultValue: "&", comment: "Ampersand separator for URL parameters in NPM package URL")))
        for pair in paramPairs {
            let keyValue = pair.split(separator: Character(String(localized: "npm.separator.equals", defaultValue: "=", comment: "Equals separator for key-value pairs in NPM package URL")), maxSplits: 1)
            guard keyValue.count == 2 else { continue }

            let key = String(keyValue[0])
            let value = String(keyValue[1])

            if key == String(localized: "npm.param.repository.url", defaultValue: "repository_url", comment: "NPM package parameter name for repository URL") {
                repositoryUrl = value
            } else if key == String(localized: "npm.param.rev", defaultValue: "rev", comment: "NPM package parameter name for git revision") && value.lowercased() == String(localized: "npm.value.true", defaultValue: "true", comment: "Boolean true value for NPM package parameters") {
                gitReference = .revision(version)
            } else if key == String(localized: "npm.param.tag", defaultValue: "tag", comment: "NPM package parameter name for git tag") && value.lowercased() == String(localized: "npm.value.true.tag", defaultValue: "true", comment: "Boolean true value for git tag parameter") {
                gitReference = .tag(version)
            } else {
                options[key] = value
            }
        }

        let source = PackageSource(
            sourceId: sourceId,
            type: .npm,
            pkgName: packageName,
            entryName: entry.name,
            version: version,
            repositoryUrl: repositoryUrl,
            gitReference: gitReference,
            options: options
        )
        return .standardPackage(source: source)
    }

    private static func parseNPMPackageNameAndVersion(_ packageVersion: String) -> (String, String) {
        var packageName: String
        var version: String = String(localized: "npm.version.default", defaultValue: "latest", comment: "Default NPM package version when not specified")

        let atChar = Character(String(localized: "npm.separator.at", defaultValue: "@", comment: "At sign separator for NPM package version"))
        if packageVersion.contains(atChar) && !packageVersion.hasPrefix(String(localized: "npm.separator.at.prefix", defaultValue: "@", comment: "At sign prefix for scoped NPM packages")) {
            // Regular package with version: package@1.0.0
            let parts = packageVersion.split(separator: atChar, maxSplits: 1)
            packageName = String(parts[0])
            if parts.count > 1 {
                version = String(parts[1])
            }
        } else if packageVersion.hasPrefix(String(localized: "npm.separator.at.scoped", defaultValue: "@", comment: "At sign prefix for scoped NPM package names")) {
            // Scoped package: @org/package@1.0.0
            if let atIndex = packageVersion[
                packageVersion.index(after: packageVersion.startIndex)...
            ].firstIndex(of: atChar) {
                packageName = String(packageVersion[..<atIndex])
                version = String(packageVersion[packageVersion.index(after: atIndex)...])
            } else {
                packageName = packageVersion
            }
        } else {
            packageName = packageVersion
        }

        return (packageName, version)
    }
}
