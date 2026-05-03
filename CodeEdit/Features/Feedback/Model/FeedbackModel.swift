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
    @Published var issueAreaListSelection: FeedbackIssueArea.ID = String(localized: "feedback.issue_area.none.id", defaultValue: "none", comment: "Issue area none ID")
    @Published var feedbackTypeListSelection: FeedbackType.ID = String(localized: "feedback.type.none.id", defaultValue: "none", comment: "Feedback type none ID")

    @Published var feedbackTypeList = [
        FeedbackType(name: String(localized: "feedback.type.choose", defaultValue: "Choose...", comment: "Choose feedback type placeholder"), id: String(localized: "feedback.type.none.id", defaultValue: "none", comment: "Feedback type none ID")),
        FeedbackType(name: String(localized: "feedback.type.behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Incorrect/unexpected behaviour feedback type"), id: String(localized: "feedback.type.behaviour.id", defaultValue: "behaviour", comment: "Behaviour feedback type ID")),
        FeedbackType(name: String(localized: "feedback.type.crash", defaultValue: "Application Crash", comment: "Application crash feedback type"), id: String(localized: "feedback.type.crash.id", defaultValue: "crash", comment: "Crash feedback type ID")),
        FeedbackType(name: String(localized: "feedback.type.unresponsive", defaultValue: "Application Slow/Unresponsive", comment: "Application slow/unresponsive feedback type"), id: String(localized: "feedback.type.unresponsive.id", defaultValue: "unresponsive", comment: "Unresponsive feedback type ID")),
        FeedbackType(name: String(localized: "feedback.type.suggestion", defaultValue: "Suggestion", comment: "Suggestion feedback type"), id: String(localized: "feedback.type.suggestion.id", defaultValue: "suggestions", comment: "Suggestion feedback type ID")),
        FeedbackType(name: String(localized: "feedback.type.other", defaultValue: "Other", comment: "Other feedback type"), id: String(localized: "feedback.type.other.id", defaultValue: "other", comment: "Other feedback type ID"))
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.select", defaultValue: "Please select the problem area", comment: "Select problem area placeholder"), id: String(localized: "feedback.issue_area.none.id", defaultValue: "none", comment: "Issue area none ID")),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.project_navigator", defaultValue: "Project Navigator", comment: "Project Navigator issue area"), id: String(localized: "feedback.issue_area.project_navigator.id", defaultValue: "projectNavigator", comment: "Project Navigator issue area ID")),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.extensions", defaultValue: "Extensions", comment: "Extensions issue area"), id: String(localized: "feedback.issue_area.extensions.id", defaultValue: "extensions", comment: "Extensions issue area ID")),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.git", defaultValue: "Git", comment: "Git issue area"), id: String(localized: "feedback.issue_area.git.id", defaultValue: "git", comment: "Git issue area ID")),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.debugger", defaultValue: "Debugger", comment: "Debugger issue area"), id: String(localized: "feedback.issue_area.debugger.id", defaultValue: "debugger", comment: "Debugger issue area ID")),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.editor", defaultValue: "Editor", comment: "Editor issue area"), id: String(localized: "feedback.issue_area.editor.id", defaultValue: "editor", comment: "Editor issue area ID")),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.other", defaultValue: "Other", comment: "Other issue area"), id: String(localized: "feedback.issue_area.other.id", defaultValue: "other", comment: "Other issue area ID"))
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case String(localized: "feedback.issue_area.project_navigator.id", defaultValue: "projectNavigator", comment: "Project Navigator issue area ID"):
            return String(localized: "feedback.issue_area.project_navigator", defaultValue: "Project Navigator", comment: "Project Navigator issue area")
        case String(localized: "feedback.issue_area.extensions.id", defaultValue: "extensions", comment: "Extensions issue area ID"):
            return String(localized: "feedback.issue_area.extensions", defaultValue: "Extensions", comment: "Extensions issue area")
        case String(localized: "feedback.issue_area.git.id", defaultValue: "git", comment: "Git issue area ID"):
            return String(localized: "feedback.issue_area.git", defaultValue: "Git", comment: "Git issue area")
        case String(localized: "feedback.issue_area.debugger.id", defaultValue: "debugger", comment: "Debugger issue area ID"):
            return String(localized: "feedback.issue_area.debugger", defaultValue: "Debugger", comment: "Debugger issue area")
        case String(localized: "feedback.issue_area.editor.id", defaultValue: "editor", comment: "Editor issue area ID"):
            return String(localized: "feedback.issue_area.editor", defaultValue: "Editor", comment: "Editor issue area")
        case String(localized: "feedback.issue_area.other.id", defaultValue: "other", comment: "Other issue area ID"):
            return String(localized: "feedback.issue_area.other", defaultValue: "Other", comment: "Other issue area")
        default:
            return String(localized: "feedback.issue_area.other", defaultValue: "Other", comment: "Other issue area")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.type.behaviour.id", defaultValue: "behaviour", comment: "Behaviour feedback type ID"):
            return String(localized: "feedback.type.bug_emoji", defaultValue: "🐞", comment: "Bug emoji for feedback type")
        case String(localized: "feedback.type.crash.id", defaultValue: "crash", comment: "Crash feedback type ID"):
            return String(localized: "feedback.type.bug_emoji", defaultValue: "🐞", comment: "Bug emoji for feedback type")
        case String(localized: "feedback.type.unresponsive.id", defaultValue: "unresponsive", comment: "Unresponsive feedback type ID"):
            return String(localized: "feedback.type.bug_emoji", defaultValue: "🐞", comment: "Bug emoji for feedback type")
        case String(localized: "feedback.type.suggestion.id", defaultValue: "suggestions", comment: "Suggestion feedback type ID"):
            return String(localized: "feedback.type.suggestion_emoji", defaultValue: "✨", comment: "Suggestion emoji for feedback type")
        case String(localized: "feedback.type.other.id", defaultValue: "other", comment: "Other feedback type ID"):
            return String(localized: "feedback.type.feedback_emoji", defaultValue: "📬", comment: "Feedback emoji for other type")
        default:
            return String(localized: "feedback.type.other", defaultValue: "Other", comment: "Other feedback type")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.type.behaviour.id", defaultValue: "behaviour", comment: "Behaviour feedback type ID"):
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Bug label")
        case String(localized: "feedback.type.crash.id", defaultValue: "crash", comment: "Crash feedback type ID"):
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Bug label")
        case String(localized: "feedback.type.unresponsive.id", defaultValue: "unresponsive", comment: "Unresponsive feedback type ID"):
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Bug label")
        case String(localized: "feedback.type.suggestion.id", defaultValue: "suggestions", comment: "Suggestion feedback type ID"):
            return String(localized: "feedback.label.suggestion", defaultValue: "Suggestion", comment: "Suggestion label")
        case String(localized: "feedback.type.other.id", defaultValue: "other", comment: "Other feedback type ID"):
            return String(localized: "feedback.label.feedback", defaultValue: "Feedback", comment: "Feedback label")
        default:
            return String(localized: "feedback.label.other", defaultValue: "Other", comment: "Other label")
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
        String(format: String(localized: "feedback.issue_body_template", defaultValue: """
        **Description**

        %@

        **Steps to Reproduce**

        %@

        **What did you expect to happen?**

        %@

        **What actually happened?**

        %@
        """, comment: "Issue body template with description, steps, expectation, and actual result"), description, steps ?? String(localized: "feedback.not_applicable", defaultValue: "N/A", comment: "Not applicable placeholder"), expectation ?? String(localized: "feedback.not_applicable", defaultValue: "N/A", comment: "Not applicable placeholder"), actuallyHappened ?? String(localized: "feedback.not_applicable", defaultValue: "N/A", comment: "Not applicable placeholder"))
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
            owner: String(localized: "feedback.github_owner", defaultValue: "CodeEditApp", comment: "GitHub repository owner"),
            repository: String(localized: "feedback.github_repo", defaultValue: "CodeEdit", comment: "GitHub repository name"),
            title: String(format: String(localized: "feedback.issue_title_format", defaultValue: "%@ %@", comment: "Issue title format with emoji and title"), getFeedbackTypeTitle(), title),
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
                    self.openIssueURL(issue.htmlURL ?? URL(string: String(localized: "feedback.github_issues_url", defaultValue: "https://github.com/CodeEditApp/CodeEdit/issues", comment: "GitHub issues URL"))!)
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
