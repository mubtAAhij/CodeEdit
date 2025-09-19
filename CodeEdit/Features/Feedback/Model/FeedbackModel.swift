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
        FeedbackType(name: String(localized: "feedback_choose", comment: "Default option in feedback type picker"), id: "none"),
        FeedbackType(name: String(localized: "feedback_incorrect_behavior", comment: "Feedback type for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback_application_crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback_application_slow", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback_suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback_other", comment: "Generic other option in feedback type"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback_select_problem_area", comment: "Default option in issue area picker"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback_project_navigator", comment: "Issue area option for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback_extensions", comment: "Issue area option for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback_git", comment: "Issue area option for Git functionality"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback_debugger", comment: "Issue area option for debugger"), id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback_other_area", comment: "Generic other option in issue area"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback_project_navigator", comment: "Issue area label for project navigator")
        case "extensions":
            return String(localized: "feedback_extensions", comment: "Issue area label for extensions")
        case "git":
            return String(localized: "feedback_git", comment: "Issue area label for Git functionality")
        case "debugger":
            return String(localized: "feedback_debugger", comment: "Issue area label for debugger")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "feedback_other_area", comment: "Generic other option in issue area switch")
        default:
            return String(localized: "feedback_other_area", comment: "Default fallback for issue area")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback_bug_emoji", comment: "Bug emoji for feedback types")
        case "crash":
            return String(localized: "bug_emoji", comment: "Bug emoji for feedback type")
        case "unresponsive":
            return String(localized: "bug_emoji", comment: "Bug emoji for feedback type")
        case "suggestions":
            return String(localized: "suggestion_emoji", comment: "Suggestion emoji for feedback type")
        case "other":
            return String(localized: "feedback_emoji", comment: "Feedback emoji for other feedback type")
        default:
            return String(localized: "other", comment: "Other feedback type label")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "bug", comment: "Bug feedback label")
        case "crash":
            return String(localized: "bug", comment: "Bug feedback label")
        case "unresponsive":
            return String(localized: "bug", comment: "Bug feedback label")
        case "suggestions":
            return String(localized: "suggestion", comment: "Suggestion feedback label")
        case "other":
            return String(localized: "feedback", comment: "General feedback label")
        default:
            return String(localized: "other", comment: "Other feedback type label")
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
