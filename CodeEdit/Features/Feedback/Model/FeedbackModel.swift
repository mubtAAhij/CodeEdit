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
        FeedbackType(name: String(localized: "feedback-model.choose", defaultValue: "Choose...", comment: "Placeholder for feedback type selection"), id: "none"),
        FeedbackType(name: String(localized: "feedback-model.incorrect-behavior", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type for incorrect behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback-model.crash", defaultValue: "Application Crash", comment: "Feedback type for application crash"), id: "crash"),
        FeedbackType(name: String(localized: "feedback-model.slow-unresponsive", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type for slow/unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback-model.suggestion", defaultValue: "Suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback-model.other", defaultValue: "Other", comment: "Feedback type for other issues"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback-model.select-area", defaultValue: "Please select the problem area", comment: "Placeholder for issue area selection"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback-model.project-navigator", defaultValue: "Project Navigator", comment: "Issue area for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback-model.extensions", defaultValue: "Extensions", comment: "Issue area for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback-model.git", defaultValue: "Git", comment: "Issue area for Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback-model.debugger", defaultValue: "Debugger", comment: "Issue area for debugger"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback-model.editor", defaultValue: "Editor", comment: "Issue area for editor"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback-model.other-area", defaultValue: "Other", comment: "Issue area for other"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback-model.label-project-navigator", defaultValue: "Project Navigator", comment: "Label for project navigator")
        case "extensions":
            return String(localized: "feedback-model.label-extensions", defaultValue: "Extensions", comment: "Label for extensions")
        case "git":
            return String(localized: "feedback-model.label-git", defaultValue: "Git", comment: "Label for Git")
        case "debugger":
            return String(localized: "feedback-model.label-debugger", defaultValue: "Debugger", comment: "Label for debugger")
        case "editor":
            return String(localized: "feedback-model.label-editor", defaultValue: "Editor", comment: "Label for editor")
        case "other":
            return String(localized: "feedback-model.label-other", defaultValue: "Other", comment: "Label for other")
        default:
            return String(localized: "feedback-model.label-other-default", defaultValue: "Other", comment: "Default label for other")
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
            return String(localized: "feedback-model.type-title-other", defaultValue: "Other", comment: "Default feedback type title")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback-model.type-label-bug-behavior", defaultValue: "Bug", comment: "Bug label for behavior issues")
        case "crash":
            return String(localized: "feedback-model.type-label-bug-crash", defaultValue: "Bug", comment: "Bug label for crash issues")
        case "unresponsive":
            return String(localized: "feedback-model.type-label-bug-unresponsive", defaultValue: "Bug", comment: "Bug label for unresponsive issues")
        case "suggestions":
            return String(localized: "feedback-model.type-label-suggestion", defaultValue: "Suggestion", comment: "Suggestion label")
        case "other":
            return String(localized: "feedback-model.type-label-feedback", defaultValue: "Feedback", comment: "Feedback label for other issues")
        default:
            return String(localized: "feedback-model.type-label-other", defaultValue: "Other", comment: "Default feedback type label")
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
