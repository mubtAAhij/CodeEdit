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
        FeedbackType(name: String(localized: "feedback.type.choose", defaultValue: "Choose...", comment: "Prompt to choose feedback type"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect_behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", defaultValue: "Application Crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.unresponsive", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", defaultValue: "Suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", defaultValue: "Other", comment: "Feedback type for other issues"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.select_prompt", defaultValue: "Please select the problem area", comment: "Prompt to select problem area"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.project_navigator", defaultValue: "Project Navigator", comment: "Issue area for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.extensions", defaultValue: "Extensions", comment: "Issue area for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.git", defaultValue: "Git", comment: "Issue area for Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.debugger", defaultValue: "Debugger", comment: "Issue area for debugger"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.editor", defaultValue: "Editor", comment: "Issue area for editor"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.other", defaultValue: "Other", comment: "Issue area for other issues"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return "Project Navigator"
        case "extensions":
            return "Extensions"
        case "git":
            return "Git"
        case "debugger":
            return "Debugger"
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
            return "📬"
        default:
            return String(localized: "feedback.type.default", defaultValue: "Other", comment: "Default feedback type label")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case "crash":
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case "unresponsive":
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case "suggestions":
            return String(localized: "feedback.label.suggestion", defaultValue: "Suggestion", comment: "Label for suggestion feedback type")
        case "other":
            return String(localized: "feedback.label.feedback", defaultValue: "Feedback", comment: "Label for feedback type")
        default:
            return String(localized: "feedback.label.other", defaultValue: "Other", comment: "Default feedback label")
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
