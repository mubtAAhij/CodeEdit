//
//  BitBucketUser.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation
import SwiftUI

// TODO: DOCS (Nanashi Li)
class BitBucketUser: Codable {
    var id: String?
    var login: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login = String(localized: "bitbucket.api.field.username", defaultValue: "username", comment: "Bitbucket API field name for username (CodingKey - NOT localized in code, technical constant)")
        case name = String(localized: "bitbucket.api.field.display_name", defaultValue: "display_name", comment: "Bitbucket API field name for display name (CodingKey - NOT localized in code, technical constant)")
    }
}

class BitBucketEmail: Codable {
    var isPrimary: Bool
    var isConfirmed: Bool
    var type: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case isPrimary = String(localized: "bitbucket.api.field.is_primary", defaultValue: "is_primary", comment: "Bitbucket API field name for primary status (CodingKey - NOT localized in code, technical constant)")
        case isConfirmed = String(localized: "bitbucket.api.field.is_confirmed", defaultValue: "is_confirmed", comment: "Bitbucket API field name for confirmed status (CodingKey - NOT localized in code, technical constant)")
        case type = String(localized: "bitbucket.api.field.type", defaultValue: "type", comment: "Bitbucket API field name for type (CodingKey - NOT localized in code, technical constant)")
        case email = String(localized: "bitbucket.api.field.email", defaultValue: "email", comment: "Bitbucket API field name for email (CodingKey - NOT localized in code, technical constant)")
    }
}

extension BitBucketAccount {

    func me(
        _ session: GitURLSession = URLSession.shared,
        completion: @escaping (_ response: Result<BitBucketUser, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {

            let router = BitBucketUserRouter.readAuthenticatedUser(configuration)

            return router.load(
                session,
                dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
                expectedResultType: BitBucketUser.self
            ) { user, error in
                if let error {
                    completion(.failure(error))
                } else {
                    if let user {
                        completion(.success(user))
                    }
                }
            }
        }

    func emails(
        _ session: GitURLSession = URLSession.shared,
        completion: @escaping (_ response: Result<BitBucketEmail, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {

            let router = BitBucketUserRouter.readEmails(configuration)

            return router.load(
                session,
                dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
                expectedResultType: BitBucketEmail.self
            ) { email, error in
                if let error {
                    completion(.failure(error))
                } else {
                    if let email {
                        completion(.success(email))
                    }
                }
            }
    }
}
