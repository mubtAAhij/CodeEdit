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
        case login = String(localized: "swift.preflight.literal.437500", defaultValue: "username", comment: "")
        case name = String(localized: "swift.preflight.literal.437501", defaultValue: "display_name", comment: "")
    }
}

class BitBucketEmail: Codable {
    var isPrimary: Bool
    var isConfirmed: Bool
    var type: String?
    var email: String?

    enum CodingKeys: String, CodingKey {
        case isPrimary = String(localized: "swift.preflight.literal.437502", defaultValue: "is_primary", comment: "")
        case isConfirmed = String(localized: "swift.preflight.literal.437503", defaultValue: "is_confirmed", comment: "")
        case type = String(localized: "swift.preflight.literal.437504", defaultValue: "type", comment: "")
        case email = String(localized: "swift.preflight.literal.437505", defaultValue: "email", comment: "")
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
