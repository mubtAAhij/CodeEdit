//
//  FeedbackModel.swift
//  CodeEditModules/Feedback
//
//  Created by Nanashi Li on 2022/04/14.
//

import SwiftUI

public class FeedbackModel: ObservableObject {

    public static let shared: FeedbackModel = .init()

    private let keychain = CodeEditKeychain()

    @Environment(\.openURL)
    var openIssueURL

    @Published var isSubmitted: Bool = false
    @Published var failedToSubmit: Bool = false
    @Published var feedbackTitle: String = ""
    @Published var issueDescription: String = ""
    @Published var stepsReproduceDescription: String = ""
    @Published var expectationDescription: String = ""
    @Published var whatHappenedDescription: String = ""
    @Published var issueAreaListSelection: FeedbackIssueArea.ID = "none"
    @Published var feedbackTypeListSelection: FeedbackType.ID = "none"

    @Published var feedbackTypeList = [
        FeedbackType(name: String(localized: "Choose...", comment: "Feedback type option"), id: "none"),
        FeedbackType(name: String(localized: "Incorrect/Unexpected Behaviour", comment: "Feedback type option"), id: "behaviour"),
        FeedbackType(name: String(localized: "Application Crash", comment: "Feedback type option"), id: "crash"),
        FeedbackType(name: String(localized: "Application Slow/Unresponsive", comment: "Feedback type option"), id: "unresponsive"),
        FeedbackType(name: String(localized: "Suggestion", comment: "Feedback type option"), id: "suggestions"),
        FeedbackType(name: String(localized: "Other", comment: "Feedback type option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "Please select the problem area", comment: "Issue area option"), id: "none"),
        FeedbackIssueArea(name: String(localized: "Project Navigator", comment: "Issue area option"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "Extensions", comment: "Issue area option"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "Git", comment: "Issue area option"), id: "git"),
        FeedbackIssueArea(name: String(localized: "Debugger", comment: "Issue area option"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "Editor", comment: "Issue area option"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "Other", comment: "Issue area option"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "Project Navigator", comment: "Issue label")
        case "extensions":
            return String(localized: "Extensions", comment: "Issue label")
        case "git":
            return String(localized: "Git", comment: "Issue label")
        case "debugger":
            return String(localized: "Debugger", comment: "Issue label")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "Other", comment: "Issue label")
        default:
            return String(localized: "Other", comment: "Issue label")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "🐞", comment: "Bug emoji")
        case "crash":
            return String(localized: "🐞", comment: "Bug emoji")
        case "unresponsive":
            return String(localized: "🐞", comment: "Bug emoji")
        case "suggestions":
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "Other", comment: "Feedback type")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "Bug", comment: "Feedback label")
        case "crash":
            return String(localized: "Bug", comment: "Feedback label")
        case "unresponsive":
            return String(localized: "Bug", comment: "Feedback label")
        case "suggestions":
            return String(localized: "Suggestion", comment: "Feedback label")
        case "other":
            return String(localized: "Feedback", comment: "Feedback label")
        default:
            return String(localized: "Other", comment: "Feedback label")
        }
    }

    /// The format for the issue body is how it will be displayed on
    /// repos issues. If any changes are made use markdown format
    /// because the text gets converted when created.
    private func createIssueBody(
        description: String,
        steps: String?,
        expectation: String?,
        actuallyHappened: String?
    ) -> String {
        String(localized: """
        **Description**

        \(description)

        **Steps to Reproduce**

        \(steps ?? "N/A")

        **What did you expect to happen?**

        \(expectation ?? "N/A")

        **What actually happened?**

        \(actuallyHappened ?? "N/A")
        """, comment: "Issue body template")
    }

    public func createIssue(
        title: String,
        description: String,
        steps: String?,
        expectation: String?,
        actuallyHappened: String?
    ) {
        let gitAccounts = Settings[\.accounts].sourceControlAccounts.gitAccounts
        let firstGitAccount = gitAccounts.first

        let config = GitHubTokenConfiguration(keychain.get(firstGitAccount!.name))
        GitHubAccount(config).postIssue(
            owner: "CodeEditApp",
            repository: "CodeEdit",
            title: "\(getFeedbackTypeTitle()) \(title)",
            body: createIssueBody(
                description: description,
                steps: steps,
                expectation: expectation,
                actuallyHappened: actuallyHappened
            ),
            assignee: "",
            labels: [getFeedbackTypeLabel(), getIssueLabel()]
        ) { response in
            switch response {
            case .success(let issue):
                if Settings[\.sourceControl].general.openFeedbackInBrowser {
                    self.openIssueURL(issue.htmlURL ?? URL(string: "https://github.com/CodeEditApp/CodeEdit/issues")!)
                }
                self.isSubmitted.toggle()
                print(issue)
            case .failure(let error):
                self.failedToSubmit.toggle()
                print(error)
            }
        }
    }
}
