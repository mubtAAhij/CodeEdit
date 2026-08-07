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
        location.split(separator: "/").last?.replacingOccurrences(of: String(localized: "about.acknowledgements.parse-packages-resolved.git-suffix", defaultValue: ".git", comment: "Git repository suffix used when normalizing package URLs"), with: "") ?? identity
    }
}

// MARK: - State
struct AcknowledgementPackageState: Codable {
    let revision: String
    let version: String?
}
