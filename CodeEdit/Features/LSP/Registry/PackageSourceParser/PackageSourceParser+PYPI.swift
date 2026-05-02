//
//  PackageSourceParser+PYPI.swift
//  CodeEdit
//
//  Created by Abe Malla on 3/12/25.
//

extension PackageSourceParser {
    static func parsePythonPackage(_ entry: RegistryItem) -> InstallationMethod {
        // Format: pkg:pypi/PACKAGE@VERSION?PARAMS
        let pkgPrefix = String(localized: "pypi.package.prefix", defaultValue: "pkg:pypi/", comment: "PyPI package URL prefix")
        let sourceId = entry.source.id
        guard sourceId.hasPrefix(pkgPrefix) else { return .unknown }

        let pkgString = sourceId.dropFirst(pkgPrefix.count)

        let components = pkgString.split(separator: Character(String(localized: "pypi.separator.query", defaultValue: "?", comment: "PyPI query parameter separator")), maxSplits: 1)
        let packageVersion = String(components[0])
        let parameters = components.count > 1 ? String(components[1]) : ""

        let packageVersionParts = packageVersion.split(separator: Character(String(localized: "pypi.separator.version", defaultValue: "@", comment: "PyPI version separator")), maxSplits: 1)
        guard packageVersionParts.count >= 1 else { return .unknown }

        let packageName = String(packageVersionParts[0])
        let version = packageVersionParts.count > 1 ? String(packageVersionParts[1]) : String(localized: "pypi.version.latest", defaultValue: "latest", comment: "PyPI latest version string")

        // Parse parameters as options
        var options: [String: String] = [String(localized: "pypi.option.build.tool", defaultValue: "buildTool", comment: "PyPI build tool option key"): String(localized: "pypi.build.tool.pip", defaultValue: "pip", comment: "PyPI pip build tool")]
        var repositoryUrl: String?
        var gitReference: PackageSource.GitReference?

        let paramPairs = parameters.split(separator: Character(String(localized: "pypi.separator.param", defaultValue: "&", comment: "PyPI parameter separator")))
        for pair in paramPairs {
            let keyValue = pair.split(separator: Character(String(localized: "pypi.separator.keyvalue", defaultValue: "=", comment: "PyPI key-value separator")), maxSplits: 1)
            guard keyValue.count == 2 else { continue }

            let key = String(keyValue[0])
            let value = String(keyValue[1])

            if key == String(localized: "pypi.param.repository.url", defaultValue: "repository_url", comment: "PyPI repository URL parameter name") {
                repositoryUrl = value
            } else if key == String(localized: "pypi.param.rev", defaultValue: "rev", comment: "PyPI revision parameter name") && value.lowercased() == String(localized: "pypi.value.true", defaultValue: "true", comment: "PyPI true value") {
                gitReference = .revision(version)
            } else if key == String(localized: "pypi.param.tag", defaultValue: "tag", comment: "PyPI tag parameter name") && value.lowercased() == String(localized: "pypi.value.true", defaultValue: "true", comment: "PyPI true value") {
                gitReference = .tag(version)
            } else {
                options[key] = value
            }
        }

        let source = PackageSource(
            sourceId: sourceId,
            type: .pip,
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
