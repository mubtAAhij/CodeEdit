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
        FeedbackType(name: String(localized: "choose_option", comment: "Default option in picker"), id: "none"),
        FeedbackType(name: String(localized: "feedback_type_unexpected_behavior", comment: "Feedback type for unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback_type_crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback_type_performance", comment: "Feedback type for performance issues"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback_type_suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: "Other", id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "select_problem_area", comment: "Default option for problem area selection"), id: "none"),
        FeedbackIssueArea(name: String(localized: "area_project_navigator", comment: "Project Navigator area option"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "area_extensions", comment: "Extensions area option"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "area_git", comment: "Git area option"), id: "git"),
        FeedbackIssueArea(name: String(localized: "area_debugger", comment: "Debugger area option"), id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: "Other", id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "area_project_navigator", comment: "Project Navigator area option")
        case "extensions":
            return String(localized: "area_extensions", comment: "Extensions area option")
        case "git":
            return String(localized: "area_git", comment: "Git area option")
        case "debugger":
            return String(localized: "area_debugger", comment: "Debugger area option")
        case "editor":
            return "Editor"
        case "other":
            return "Other"
        default:
            return "Other"
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return "🐞"
        case "crash":
            return "🐞"
        case "unresponsive":
            return "🐞"
        case "suggestions":
            return "✨"
        case "other":
            return String(localized: "feedback_emoji_other", comment: "Emoji for other feedback type")
        default:
            return "Other"
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "label_bug", comment: "Bug label for feedback")
        case "crash":
            return String(localized: "label_bug", comment: "Bug label for feedback")
        case "unresponsive":
            return String(localized: "label_bug", comment: "Bug label for feedback")
        case "suggestions":
            return String(localized: "label_suggestion", comment: "Suggestion label for feedback")
        case "other":
            return String(localized: "label_feedback", comment: "Generic feedback label")
        default:
            return "Other"
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
        """
        **Description**

        \(description)

        **Steps to Reproduce**

        \(steps ?? "N/A")

        **What did you expect to happen?**

        \(expectation ?? "N/A")

        **What actually happened?**

        \(actuallyHappened ?? "N/A")
        """
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
