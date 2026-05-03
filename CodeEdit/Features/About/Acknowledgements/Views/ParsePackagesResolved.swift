//
//  ParsePackagesResolved.swift
//  CodeEditModules/Acknowledgements
//
//  Created by Shivesh M M on 4/4/22.
//

import Foundation

struct AcknowledgementDependency: Decodable {
    var name: String
    var repositoryLink: String
    var version: String
    var repositoryURL: URL {
        URL(string: repositoryLink)!
    }
}

// MARK: - Object
struct AcknowledgementObject: Codable {
    let pins: [AcknowledgementPin]
}

// MARK: - Pin
struct AcknowledgementPin: Codable {
    let identity: String
    let location: String
    let state: AcknowledgementPackageState

    var name: String {
        location.split(separator: String(localized: "path.separator", defaultValue: "/", comment: "Path separator - technical constant, should not be localized")).last?.replacingOccurrences(of: String(localized: "file.extension.git", defaultValue: ".git", comment: "Git file extension - technical constant, should not be localized"), with: "") ?? identity
    }
}

// MARK: - State
struct AcknowledgementPackageState: Codable {
    let revision: String
    let version: String?
}
