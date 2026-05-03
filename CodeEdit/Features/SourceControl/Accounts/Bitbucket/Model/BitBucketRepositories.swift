//
//  BitBucketRepositories.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

// TODO: DOCS (Nanashi Li)
class BitBucketRepositories: Codable {
    var id: String
    var owner: BitBucketUser
    var name: String?
    var fullName: String?
    var isPrivate: Bool
    var repositoryDescription: String?
    var gitURL: String?
    var sshURL: String?
    var cloneURL: String?
    var size: Int
    var scm: String?

    enum CodingKeys: String, CodingKey {
        case id = String(localized: "bitbucket.api.field.uuid", defaultValue: "uuid", comment: "Bitbucket API uuid field")
        case owner
        case name
        case fullName = String(localized: "bitbucket.api.field.full_name", defaultValue: "full_name", comment: "Bitbucket API full_name field")
        case isPrivate = String(localized: "bitbucket.api.field.is_private", defaultValue: "is_private", comment: "Bitbucket API is_private field")
        case repositoryDescription = String(localized: "bitbucket.api.field.description", defaultValue: "description", comment: "Bitbucket API description field")
        case gitURL = String(localized: "bitbucket.api.field.git_url", defaultValue: "git://", comment: "Bitbucket API git URL field")
        case sshURL = String(localized: "bitbucket.api.field.ssh_url", defaultValue: "ssh://", comment: "Bitbucket API ssh URL field")
        case cloneURL = String(localized: "bitbucket.api.field.https_url", defaultValue: "https://", comment: "Bitbucket API https URL field")
        case size
        case scm
    }
}

enum BitbucketPaginatedResponse<T> {
    case success(values: T, nextParameters: [String: String])
    case failure(Error)
}

extension BitBucketAccount {

    func repositories(
        _ session: GitURLSession = URLSession.shared,
        userName: String? = nil,
        nextParameters: [String: String] = [:],
        completion: @escaping (_ response: BitbucketPaginatedResponse<[BitBucketRepositories]>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = BitBucketRepositoryRouter.readRepositories(configuration, userName, nextParameters)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: BitBucketRepositories.self
        ) { repo, error in

            if let error {
                completion(BitbucketPaginatedResponse.failure(error))
            } else {
                if let repo {
                    completion(BitbucketPaginatedResponse.success(values: [repo], nextParameters: [:]))
                }
            }
        }
    }

    func repository(
        _ session: GitURLSession = URLSession.shared,
        owner: String,
        name: String,
        completion: @escaping (_ response: Result<BitBucketRepositories, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let router = BitBucketRepositoryRouter.readRepository(configuration, owner, name)

        return router.load(
            session,
            dateDecodingStrategy: .formatted(GitTime.rfc3339DateFormatter),
            expectedResultType: BitBucketRepositories.self
        ) { data, error in

            if let error {
                completion(Result.failure(error))
            }

            if let data {
                completion(Result.success(data))
            }
        }
    }
}
