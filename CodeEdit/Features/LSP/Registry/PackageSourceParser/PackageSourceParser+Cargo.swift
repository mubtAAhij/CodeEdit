//
//  PackageSourceParser+Cargo.swift
//  CodeEdit
//
//  Created by Abe Malla on 3/12/25.
//

extension PackageSourceParser {
    static func parseCargoPackage(_ entry: RegistryItem) -> InstallationMethod {
        // Format: pkg:cargo/PACKAGE@VERSION?PARAMS
        let pkgPrefix = String(localized: "cargo.package.prefix", defaultValue: "pkg:cargo/", comment: "Cargo package URL prefix")
        let sourceId = entry.source.id.removingPercentEncoding ?? entry.source.id
        guard sourceId.hasPrefix(pkgPrefix) else { return .unknown }

        let pkgString = sourceId.dropFirst(pkgPrefix.count)

        let components = pkgString.split(separator: Character(String(localized: "cargo.url.query.separator", defaultValue: "?", comment: "Query parameter separator in Cargo package URL")), maxSplits: 1)
        let packageVersion = String(components[0])
        let parameters = components.count > 1 ? String(components[1]) : ""

        let packageVersionParts = packageVersion.split(separator: Character(String(localized: "cargo.version.separator", defaultValue: "@", comment: "Version separator in Cargo package URL")), maxSplits: 1)
        guard packageVersionParts.count >= 1 else { return .unknown }

        let packageName = String(packageVersionParts[0])
        let version = packageVersionParts.count > 1 ? String(packageVersionParts[1]) : String(localized: "cargo.version.latest", defaultValue: "latest", comment: "Default version identifier for latest Cargo package")

        // Parse parameters as options
        var options: [String: String] = [String(localized: "cargo.option.build.tool", defaultValue: "buildTool", comment: "Build tool option key for Cargo packages"): String(localized: "cargo.build.tool.name", defaultValue: "cargo", comment: "Cargo build tool name")]
        var repositoryUrl: String?
        var gitReference: PackageSource.GitReference?

        let paramPairs = parameters.split(separator: Character(String(localized: "cargo.param.separator", defaultValue: "&", comment: "Parameter separator in Cargo package URL")))
        for pair in paramPairs {
            let keyValue = pair.split(separator: Character(String(localized: "cargo.key.value.separator", defaultValue: "=", comment: "Key-value separator in Cargo package URL parameters")), maxSplits: 1)
            guard keyValue.count == 2 else { continue }

            let key = String(keyValue[0])
            let value = String(keyValue[1])

            if key == String(localized: "cargo.param.repository.url", defaultValue: "repository_url", comment: "Repository URL parameter key for Cargo packages") {
                repositoryUrl = value
            } else if key == String(localized: "cargo.param.rev", defaultValue: "rev", comment: "Revision parameter key for Cargo packages") && value.lowercased() == String(localized: "cargo.param.value.true", defaultValue: "true", comment: "True value for Cargo package parameters") {
                gitReference = .revision(version)
            } else if key == String(localized: "cargo.param.tag", defaultValue: "tag", comment: "Tag parameter key for Cargo packages") && value.lowercased() == String(localized: "cargo.param.value.true.tag", defaultValue: "true", comment: "True value for Cargo package tag parameter") {
                gitReference = .tag(version)
            } else {
                options[key] = value
            }
        }

        // If we have a repository URL but no git reference specified,
        // default to tag for versions and revision for commit hashes
        if repositoryUrl != nil, gitReference == nil {
            if version.range(of: String(localized: "cargo.git.commit.hash.pattern", defaultValue: "^[0-9a-f]{40}$", comment: "Regular expression pattern for Git commit hash (40 hex characters)"), options: .regularExpression) != nil {
                gitReference = .revision(version)
            } else {
                gitReference = .tag(version)
            }
        }

        let source = PackageSource(
            sourceId: sourceId,
            type: .cargo,
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
