//
//  PackageSourceParser+Gem.swift
//  CodeEdit
//
//  Created by Abe Malla on 3/12/25.
//

extension PackageSourceParser {
    static func parseRubyGem(_ entry: RegistryItem) -> InstallationMethod {
        // Format: pkg:gem/PACKAGE@VERSION?PARAMS
        let pkgPrefix = String(localized: "gem.package.prefix", defaultValue: "pkg:gem/", comment: "Ruby Gem package URL prefix")
        let sourceId = entry.source.id.removingPercentEncoding ?? entry.source.id
        guard sourceId.hasPrefix(pkgPrefix) else { return .unknown }

        let pkgString = sourceId.dropFirst(pkgPrefix.count)

        let components = pkgString.split(separator: Character(String(localized: "gem.separator.query", defaultValue: "?", comment: "Ruby Gem query parameter separator")), maxSplits: 1)
        let packageVersion = String(components[0])
        let parameters = components.count > 1 ? String(components[1]) : ""

        let packageVersionParts = packageVersion.split(separator: Character(String(localized: "gem.separator.version", defaultValue: "@", comment: "Ruby Gem version separator")), maxSplits: 1)
        guard packageVersionParts.count >= 1 else { return .unknown }

        let packageName = String(packageVersionParts[0])
        let version = packageVersionParts.count > 1 ? String(packageVersionParts[1]) : String(localized: "gem.version.latest", defaultValue: "latest", comment: "Ruby Gem latest version string")

        // Parse parameters as options
        var options: [String: String] = [String(localized: "gem.option.build.tool", defaultValue: "buildTool", comment: "Ruby Gem build tool option key"): String(localized: "gem.build.tool", defaultValue: "gem", comment: "Ruby Gem build tool")]
        var repositoryUrl: String?
        var gitReference: PackageSource.GitReference?

        let paramPairs = parameters.split(separator: Character(String(localized: "gem.separator.param", defaultValue: "&", comment: "Ruby Gem parameter separator")))
        for pair in paramPairs {
            let keyValue = pair.split(separator: Character(String(localized: "gem.separator.keyvalue", defaultValue: "=", comment: "Ruby Gem key-value separator")), maxSplits: 1)
            guard keyValue.count == 2 else { continue }

            let key = String(keyValue[0])
            let value = String(keyValue[1])

            if key == String(localized: "gem.param.repository.url", defaultValue: "repository_url", comment: "Ruby Gem repository URL parameter name") {
                repositoryUrl = value
            } else if key == String(localized: "gem.param.rev", defaultValue: "rev", comment: "Ruby Gem revision parameter name") && value.lowercased() == String(localized: "gem.value.true", defaultValue: "true", comment: "Ruby Gem true value") {
                gitReference = .revision(version)
            } else if key == String(localized: "gem.param.tag", defaultValue: "tag", comment: "Ruby Gem tag parameter name") && value.lowercased() == String(localized: "gem.value.true", defaultValue: "true", comment: "Ruby Gem true value") {
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
