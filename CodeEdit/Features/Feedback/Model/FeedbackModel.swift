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
        FeedbackType(name: String(localized: "feedback.type.choose", defaultValue: "Choose...", comment: "Placeholder option for feedback type selection"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect-behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type option for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", defaultValue: "Application Crash", comment: "Feedback type option for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.slow-unresponsive", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type option for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", defaultValue: "Suggestion", comment: "Feedback type option for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", defaultValue: "Other", comment: "Feedback type option for other types of feedback"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.select-prompt", defaultValue: "Please select the problem area", comment: "Prompt to select a problem area for feedback"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.project-navigator", defaultValue: "Project Navigator", comment: "Issue area option for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.extensions", defaultValue: "Extensions", comment: "Issue area option for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.git", defaultValue: "Git", comment: "Issue area option for Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.debugger", defaultValue: "Debugger", comment: "Issue area option for debugger"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.editor", defaultValue: "Editor", comment: "Issue area option for editor"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.other", defaultValue: "Other", comment: "Issue area option for other"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.label.project-navigator", defaultValue: "Project Navigator", comment: "Label for project navigator issue area")
        case "extensions":
            return String(localized: "feedback.label.extensions", defaultValue: "Extensions", comment: "Label for extensions issue area")
        case "git":
            return String(localized: "feedback.label.git", defaultValue: "Git", comment: "Label for Git issue area")
        case "debugger":
            return String(localized: "feedback.label.debugger", defaultValue: "Debugger", comment: "Label for debugger issue area")
        case "editor":
            return String(localized: "feedback.label.editor", defaultValue: "Editor", comment: "Label for editor issue area")
        case "other":
            return String(localized: "feedback.label.other", defaultValue: "Other", comment: "Label for other issue area")
        default:
            return String(localized: "feedback.label.other", defaultValue: "Other", comment: "Label for other issue area")
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
            return "📬"
        default:
            return String(localized: "feedback.type-title.other", defaultValue: "Other", comment: "Default feedback type title for other")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.type-label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case "crash":
            return String(localized: "feedback.type-label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case "unresponsive":
            return String(localized: "feedback.type-label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case "suggestions":
            return String(localized: "feedback.type-label.suggestion", defaultValue: "Suggestion", comment: "Label for suggestion feedback type")
        case "other":
            return String(localized: "feedback.type-label.feedback", defaultValue: "Feedback", comment: "Label for general feedback type")
        default:
            return String(localized: "feedback.type-label.other", defaultValue: "Other", comment: "Label for other feedback type")
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
