//
//  BitBucketAccount+Token.swift
//  CodeEditModules/GitAccounts
//
//  Created by Nanashi Li on 2022/03/31.
//

import Foundation

// TODO: DOCS (Nanashi Li)
extension BitBucketAccount {

    func refreshToken(
        _ session: GitURLSession,
        oauthConfig: BitBucketOAuthConfiguration,
        refreshToken: String,
        completion: @escaping (_ response: Result<BitBucketTokenConfiguration, Error>) -> Void
    ) -> GitURLSessionDataTaskProtocol? {
        let request = BitBucketTokenRouter.refreshToken(oauthConfig, refreshToken).URLRequest

        var task: GitURLSessionDataTaskProtocol?

        if let request {
            task = session.dataTask(with: request) { data, response, _ in

                guard let response = response as? HTTPURLResponse else { return }

                guard let data else { return }
                do {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let responseJSON = responseJSON as? [String: AnyObject] {
                        if response.statusCode != 200 {
                            let errorDescription = responseJSON[String(localized: "bitbucket.json.error-description", defaultValue: "error_description", comment: "Bitbucket API JSON key - technical constant, should not be localized")] as? String ?? ""
                            let error = NSError(
                                domain: String(localized: "bundle.bitbucket", defaultValue: "com.codeedit.models.accounts.bitbucket", comment: "Bundle identifier - technical constant, should not be localized"),
                                code: response.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: errorDescription]
                            )
                            completion(Result.failure(error))
                        } else {
                            let tokenConfig = BitBucketTokenConfiguration(json: responseJSON)
                            completion(Result.success(tokenConfig))
                        }
                    }
                }
            }
            task?.resume()
        }
        return task
    }
}
