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
    @Published var issueAreaListSelection: FeedbackIssueArea.ID = String(localized: "feedback.issue-area.none.id", defaultValue: "none", comment: "ID for none issue area selection")
    @Published var feedbackTypeListSelection: FeedbackType.ID = String(localized: "feedback.type.none.id", defaultValue: "none", comment: "ID for none feedback type selection")

    @Published var feedbackTypeList = [
        FeedbackType(name: String(localized: "feedback.type.choose.name", defaultValue: "Choose...", comment: "Placeholder for feedback type selection"), id: String(localized: "feedback.type.none.id", defaultValue: "none", comment: "ID for none feedback type")),
        FeedbackType(name: String(localized: "feedback.type.incorrect-behaviour.name", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type for incorrect behaviour"), id: String(localized: "feedback.type.behaviour.id", defaultValue: "behaviour", comment: "ID for behaviour feedback type")),
        FeedbackType(name: String(localized: "feedback.type.crash.name", defaultValue: "Application Crash", comment: "Feedback type for application crash"), id: String(localized: "feedback.type.crash.id", defaultValue: "crash", comment: "ID for crash feedback type")),
        FeedbackType(name: String(localized: "feedback.type.unresponsive.name", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type for slow/unresponsive application"), id: String(localized: "feedback.type.unresponsive.id", defaultValue: "unresponsive", comment: "ID for unresponsive feedback type")),
        FeedbackType(name: String(localized: "feedback.type.suggestion.name", defaultValue: "Suggestion", comment: "Feedback type for suggestion"), id: String(localized: "feedback.type.suggestions.id", defaultValue: "suggestions", comment: "ID for suggestions feedback type")),
        FeedbackType(name: String(localized: "feedback.type.other.name", defaultValue: "Other", comment: "Feedback type for other"), id: String(localized: "feedback.type.other.id", defaultValue: "other", comment: "ID for other feedback type"))
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.choose.name", defaultValue: "Please select the problem area", comment: "Placeholder for issue area selection"), id: String(localized: "feedback.issue-area.none.id", defaultValue: "none", comment: "ID for none issue area")),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.project-navigator.name", defaultValue: "Project Navigator", comment: "Issue area for project navigator"), id: String(localized: "feedback.issue-area.project-navigator.id", defaultValue: "projectNavigator", comment: "ID for project navigator issue area")),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.extensions.name", defaultValue: "Extensions", comment: "Issue area for extensions"), id: String(localized: "feedback.issue-area.extensions.id", defaultValue: "extensions", comment: "ID for extensions issue area")),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.git.name", defaultValue: "Git", comment: "Issue area for git"), id: String(localized: "feedback.issue-area.git.id", defaultValue: "git", comment: "ID for git issue area")),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.debugger.name", defaultValue: "Debugger", comment: "Issue area for debugger"), id: String(localized: "feedback.issue-area.debugger.id", defaultValue: "debugger", comment: "ID for debugger issue area")),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.editor.name", defaultValue: "Editor", comment: "Issue area for editor"), id: String(localized: "feedback.issue-area.editor.id", defaultValue: "editor", comment: "ID for editor issue area")),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.other.name", defaultValue: "Other", comment: "Issue area for other"), id: String(localized: "feedback.issue-area.other.id", defaultValue: "other", comment: "ID for other issue area"))
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case String(localized: "feedback.issue-area.project-navigator.id", defaultValue: "projectNavigator", comment: "ID for project navigator issue area"):
            return String(localized: "feedback.issue-area.project-navigator.name", defaultValue: "Project Navigator", comment: "Issue area for project navigator")
        case String(localized: "feedback.issue-area.extensions.id", defaultValue: "extensions", comment: "ID for extensions issue area"):
            return String(localized: "feedback.issue-area.extensions.name", defaultValue: "Extensions", comment: "Issue area for extensions")
        case String(localized: "feedback.issue-area.git.id", defaultValue: "git", comment: "ID for git issue area"):
            return String(localized: "feedback.issue-area.git.name", defaultValue: "Git", comment: "Issue area for git")
        case String(localized: "feedback.issue-area.debugger.id", defaultValue: "debugger", comment: "ID for debugger issue area"):
            return String(localized: "feedback.issue-area.debugger.name", defaultValue: "Debugger", comment: "Issue area for debugger")
        case String(localized: "feedback.issue-area.editor.id", defaultValue: "editor", comment: "ID for editor issue area"):
            return String(localized: "feedback.issue-area.editor.name", defaultValue: "Editor", comment: "Issue area for editor")
        case String(localized: "feedback.issue-area.other.id", defaultValue: "other", comment: "ID for other issue area"):
            return String(localized: "feedback.issue-area.other.name", defaultValue: "Other", comment: "Issue area for other")
        default:
            return String(localized: "feedback.issue-area.other.name", defaultValue: "Other", comment: "Issue area for other")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.type.behaviour.id", defaultValue: "behaviour", comment: "ID for behaviour feedback type"):
            return String(localized: "feedback.type.title.bug-emoji", defaultValue: "🐞", comment: "Bug emoji for feedback type title")
        case String(localized: "feedback.type.crash.id", defaultValue: "crash", comment: "ID for crash feedback type"):
            return String(localized: "feedback.type.title.bug-emoji", defaultValue: "🐞", comment: "Bug emoji for feedback type title")
        case String(localized: "feedback.type.unresponsive.id", defaultValue: "unresponsive", comment: "ID for unresponsive feedback type"):
            return String(localized: "feedback.type.title.bug-emoji", defaultValue: "🐞", comment: "Bug emoji for feedback type title")
        case String(localized: "feedback.type.suggestions.id", defaultValue: "suggestions", comment: "ID for suggestions feedback type"):
            return String(localized: "feedback.type.title.sparkle-emoji", defaultValue: "✨", comment: "Sparkle emoji for suggestion feedback type title")
        case String(localized: "feedback.type.other.id", defaultValue: "other", comment: "ID for other feedback type"):
            return String(localized: "feedback.type.title.mailbox-emoji", defaultValue: "📬", comment: "Mailbox emoji for other feedback type title")
        default:
            return String(localized: "feedback.type.other.name", defaultValue: "Other", comment: "Feedback type for other")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.type.behaviour.id", defaultValue: "behaviour", comment: "ID for behaviour feedback type"):
            return String(localized: "feedback.type.label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case String(localized: "feedback.type.crash.id", defaultValue: "crash", comment: "ID for crash feedback type"):
            return String(localized: "feedback.type.label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case String(localized: "feedback.type.unresponsive.id", defaultValue: "unresponsive", comment: "ID for unresponsive feedback type"):
            return String(localized: "feedback.type.label.bug", defaultValue: "Bug", comment: "Label for bug feedback type")
        case String(localized: "feedback.type.suggestions.id", defaultValue: "suggestions", comment: "ID for suggestions feedback type"):
            return String(localized: "feedback.type.label.suggestion", defaultValue: "Suggestion", comment: "Label for suggestion feedback type")
        case String(localized: "feedback.type.other.id", defaultValue: "other", comment: "ID for other feedback type"):
            return String(localized: "feedback.type.label.feedback", defaultValue: "Feedback", comment: "Label for feedback type")
        default:
            return String(localized: "feedback.type.other.name", defaultValue: "Other", comment: "Feedback type for other")
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
        String(
            format: String(
                localized: "feedback.issue-body-template",
                defaultValue: """
                **Description**

                %@

                **Steps to Reproduce**

                %@

                **What did you expect to happen?**

                %@

                **What actually happened?**

                %@
                """,
                comment: "Template for GitHub issue body with description, steps, expectation, and actual behavior"
            ),
            description,
            steps ?? String(localized: "feedback.not-applicable", defaultValue: "N/A", comment: "Placeholder for not applicable"),
            expectation ?? String(localized: "feedback.not-applicable", defaultValue: "N/A", comment: "Placeholder for not applicable"),
            actuallyHappened ?? String(localized: "feedback.not-applicable", defaultValue: "N/A", comment: "Placeholder for not applicable")
        )
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
            owner: String(localized: "feedback.github.owner", defaultValue: "CodeEditApp", comment: "GitHub organization name"),
            repository: String(localized: "feedback.github.repository", defaultValue: "CodeEdit", comment: "GitHub repository name"),
            title: String(format: String(localized: "feedback.github.issue-title", defaultValue: "%@ %@", comment: "Issue title format with type emoji and title"), getFeedbackTypeTitle(), title),
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
                    self.openIssueURL(issue.htmlURL ?? URL(string: String(localized: "feedback.github.issues-url", defaultValue: "https://github.com/CodeEditApp/CodeEdit/issues", comment: "Fallback URL for GitHub issues"))!)
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
