//
//  PackageSourceParser+Golang.swift
//  CodeEdit
//
//  Created by Abe Malla on 3/12/25.
//

extension PackageSourceParser {
    static func parseGolangPackage(_ entry: RegistryItem) -> InstallationMethod {
        // Format: pkg:golang/PACKAGE@VERSION#SUBPATH?PARAMS
        let pkgPrefix = String(localized: "golang.package.prefix", defaultValue: "pkg:golang/", comment: "Golang package URL prefix for package parsing")
        let sourceId = entry.source.id.removingPercentEncoding ?? entry.source.id
        guard sourceId.hasPrefix(pkgPrefix) else { return .unknown }

        let pkgString = sourceId.dropFirst(pkgPrefix.count)

        // Extract subpath first if present
        let subpathComponents = pkgString.split(separator: Character(String(localized: "golang.separator.hash", defaultValue: "#", comment: "Hash character separator for subpath in Golang package URL")), maxSplits: 1)
        let packageVersionParam = String(subpathComponents[0])
        let subpath = subpathComponents.count > 1 ? String(subpathComponents[1]) : nil

        // Then split into package@version and parameters
        let components = packageVersionParam.split(separator: Character(String(localized: "golang.separator.question", defaultValue: "?", comment: "Question mark separator for parameters in Golang package URL")), maxSplits: 1)
        let packageVersion = String(components[0])
        let parameters = components.count > 1 ? String(components[1]) : ""

        let packageVersionParts = packageVersion.split(separator: Character(String(localized: "golang.separator.at", defaultValue: "@", comment: "At symbol separator for version in Golang package URL")), maxSplits: 1)
        guard packageVersionParts.count >= 1 else { return .unknown }

        let packageName = String(packageVersionParts[0])
        let version = packageVersionParts.count > 1 ? String(packageVersionParts[1]) : String(localized: "golang.version.latest", defaultValue: "latest", comment: "Default latest version identifier for Golang packages")

        // Parse parameters as options
        var options: [String: String] = [String(localized: "golang.option.build.tool", defaultValue: "buildTool", comment: "Build tool option key for Golang package"): String(localized: "golang.build.tool.golang", defaultValue: "golang", comment: "Golang build tool identifier")]
        options[String(localized: "golang.option.subpath", defaultValue: "subpath", comment: "Subpath option key for Golang package")] = subpath
        var repositoryUrl: String?
        var gitReference: PackageSource.GitReference?

        let paramPairs = parameters.split(separator: Character(String(localized: "golang.separator.ampersand", defaultValue: "&", comment: "Ampersand separator for URL parameters in Golang package URL")))
        for pair in paramPairs {
            let keyValue = pair.split(separator: Character(String(localized: "golang.separator.equals", defaultValue: "=", comment: "Equals separator for key-value pairs in Golang package URL")), maxSplits: 1)
            guard keyValue.count == 2 else { continue }

            let key = String(keyValue[0])
            let value = String(keyValue[1])

            if key == String(localized: "golang.param.repository.url", defaultValue: "repository_url", comment: "Repository URL parameter key for Golang package") {
                repositoryUrl = value
            } else if key == String(localized: "golang.param.rev", defaultValue: "rev", comment: "Revision parameter key for Golang package") && value.lowercased() == String(localized: "golang.param.value.true", defaultValue: "true", comment: "Boolean true value for Golang package parameters") {
                gitReference = .revision(version)
            } else if key == String(localized: "golang.param.tag", defaultValue: "tag", comment: "Tag parameter key for Golang package") && value.lowercased() == String(localized: "golang.param.value.true", defaultValue: "true", comment: "Boolean true value for Golang package parameters") {
                gitReference = .tag(version)
            } else {
                options[key] = value
            }
        }

        // For Go packages, the package name is often also the repository URL
        if repositoryUrl == nil {
            repositoryUrl = String(format: String(localized: "golang.repository.url.format", defaultValue: "https://%@", comment: "Default repository URL format for Golang packages"), packageName)
        }

        let source = PackageSource(
            sourceId: sourceId,
            type: .golang,
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
