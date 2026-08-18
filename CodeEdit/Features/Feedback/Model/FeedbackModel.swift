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
        FeedbackType(name: String(localized: "feedback.problem-type.choose", defaultValue: "Choose...", comment: "Picker option prompting user to choose a feedback problem type."), id: "none"),
        FeedbackType(name: String(localized: "feedback.problem-type.incorrect-unexpected-behaviour.title", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback problem type title for incorrect or unexpected behavior."), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.problem-type.application-crash.title", defaultValue: "Application Crash", comment: "Feedback problem type title for application crash reports."), id: "crash"),
        FeedbackType(name: String(localized: "feedback.problem-type.application-slow-unresponsive.title", defaultValue: "Application Slow/Unresponsive", comment: "Feedback problem type title for slow or unresponsive app reports."), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.problem-type.suggestion.title", defaultValue: "Suggestion", comment: "Feedback problem type title for suggestions."), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.problem-type.other.title", defaultValue: "Other", comment: "Feedback problem type title for other issues."), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.select-prompt", defaultValue: "Please select the problem area", comment: "Picker option prompting user to select feedback problem area."), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.project-navigator.title", defaultValue: "Project Navigator", comment: "Feedback problem area title for project navigator."), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.extensions.title", defaultValue: "Extensions", comment: "Feedback problem area title for extensions."), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.git.title", defaultValue: "Git", comment: "Feedback problem area title for Git."), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.debugger.title", defaultValue: "Debugger", comment: "Feedback problem area title for debugger."), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.editor.title", defaultValue: "Editor", comment: "Feedback problem area title for editor."), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.other.title", defaultValue: "Other", comment: "Feedback problem area title for other areas."), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.issue-area.project-navigator.title", defaultValue: "Project Navigator", comment: "Feedback issue area title for project navigator.")
        case "extensions":
            return String(localized: "feedback.issue-area.extensions.title", defaultValue: "Extensions", comment: "Feedback issue area title for extensions.")
        case "git":
            return String(localized: "feedback.issue-area.git.title", defaultValue: "Git", comment: "Feedback issue area title for Git.")
        case "debugger":
            return String(localized: "feedback.issue-area.debugger.title", defaultValue: "Debugger", comment: "Feedback issue area title for debugger.")
        case "editor":
            return String(localized: "feedback.issue-area.editor.title", defaultValue: "Editor", comment: "Feedback issue area title for editor.")
        case "other":
            return String(localized: "feedback.issue-area.other.title", defaultValue: "Other", comment: "Feedback issue area title for other areas.")
        default:
            return String(localized: "feedback.issue-area.other.value", defaultValue: "Other", comment: "Fallback feedback issue area value shown as Other.")
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
            return String(localized: "feedback.feedback-type.other.value", defaultValue: "Other", comment: "Fallback feedback type value shown as Other.")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.submission-type.bug.option", defaultValue: "Bug", comment: "Feedback submission type option for bug reports.")
        case "crash":
            return String(localized: "feedback.submission-type.bug.value", defaultValue: "Bug", comment: "Feedback submission type value for bug reports.")
        case "unresponsive":
            return String(localized: "feedback.submission-type.bug.label", defaultValue: "Bug", comment: "Feedback label text for bug submission.")
        case "suggestions":
            return String(localized: "feedback.submission-type.suggestion.label", defaultValue: "Suggestion", comment: "Feedback label text for suggestion submission.")
        case "other":
            return String(localized: "feedback.email.subject.feedback", defaultValue: "Feedback", comment: "Default feedback email subject label.")
        default:
            return String(localized: "feedback.email.subject.other", defaultValue: "Other", comment: "Fallback feedback email subject type label.")
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
                localized: "feedback.email.body.template",
                defaultValue: "**Description**\n\n        %@\n\n        **Steps to Reproduce**\n\n        %@\n\n        **What did you expect to happen?**\n\n        %@\n\n        **What actually happened?**\n\n        %@",
                comment: "Template body for feedback issue email including description and reproduction details."
            ),
            description,
            steps ?? String(localized: "feedback.common.not-available", defaultValue: "N/A", comment: "Fallback text when feedback details are not provided."),
            expectation ?? String(localized: "feedback.common.not-available", defaultValue: "N/A", comment: "Fallback text when expected behavior is not provided."),
            actuallyHappened ?? String(localized: "feedback.email.body.not-available", defaultValue: "N/A", comment: "Fallback text when actual behavior is not provided in feedback body.")
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
            owner: "CodeEditApp",
            repository: "CodeEdit",
            title: String(format: String(localized: "feedback.email.subject.composed", defaultValue: "%@ %@", comment: "Composed feedback email subject with feedback type and title."), "\(getFeedbackTypeTitle())", "\(title)"),
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
