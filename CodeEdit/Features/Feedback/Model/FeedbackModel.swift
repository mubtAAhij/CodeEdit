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
        FeedbackType(name: String(localized: "feedback.problem-type.choose.option", defaultValue: "Choose...", comment: "Default option title for selecting feedback problem type"), id: "none"),
        FeedbackType(name: String(localized: "feedback.problem-type.incorrect-unexpected-behaviour.option", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Option title for incorrect or unexpected behaviour feedback"), id: String(localized: "feedback.problem-type.behaviour.identifier", defaultValue: "behaviour", comment: "Stable identifier for behaviour feedback type")),
        FeedbackType(name: String(localized: "feedback.problem-type.application-crash.option", defaultValue: "Application Crash", comment: "Option title for application crash feedback"), id: String(localized: "feedback.problem-type.crash.identifier", defaultValue: "crash", comment: "Stable identifier for crash feedback type")),
        FeedbackType(name: String(localized: "feedback.problem-type.application-slow-unresponsive.option", defaultValue: "Application Slow/Unresponsive", comment: "Option title for slow or unresponsive application feedback"), id: String(localized: "feedback.problem-type.unresponsive.identifier", defaultValue: "unresponsive", comment: "Stable identifier for unresponsive feedback type")),
        FeedbackType(name: String(localized: "feedback.problem-type.suggestion.option", defaultValue: "Suggestion", comment: "Option title for suggestion feedback type"), id: String(localized: "feedback.problem-type.suggestions.identifier", defaultValue: "suggestions", comment: "Stable identifier for suggestions feedback type")),
        FeedbackType(name: String(localized: "feedback.problem-type.other.option", defaultValue: "Other", comment: "Option title for other feedback type"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.select.prompt", defaultValue: "Please select the problem area", comment: "Prompt asking user to select feedback problem area"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.project-navigator.option", defaultValue: "Project Navigator", comment: "Option title for project navigator problem area"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.extensions.option", defaultValue: "Extensions", comment: "Option title for extensions problem area"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.git.option", defaultValue: "Git", comment: "Option title for git problem area"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.debugger.option", defaultValue: "Debugger", comment: "Option title for debugger problem area"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.editor.option", defaultValue: "Editor", comment: "Option title for editor problem area"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.other.option", defaultValue: "Other", comment: "Option title for other problem area"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.problem-area.project-navigator.label", defaultValue: "Project Navigator", comment: "Display label for project navigator problem area")
        case "extensions":
            return String(localized: "feedback.problem-area.extensions.label", defaultValue: "Extensions", comment: "Display label for extensions problem area")
        case "git":
            return String(localized: "feedback.problem-area.git.label", defaultValue: "Git", comment: "Display label for git problem area")
        case "debugger":
            return String(localized: "feedback.problem-area.debugger.label", defaultValue: "Debugger", comment: "Display label for debugger problem area")
        case "editor":
            return String(localized: "feedback.problem-area.editor.label", defaultValue: "Editor", comment: "Display label for editor problem area")
        case "other":
            return String(localized: "feedback.problem-area.other.label", defaultValue: "Other", comment: "Display label for other problem area")
        default:
            return String(localized: "feedback.problem-area.other.slug-label", defaultValue: "Other", comment: "Other problem area fallback display value")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.problem-type.behaviour.identifier", defaultValue: "behaviour"):
            return "🐞"
        case String(localized: "feedback.problem-type.crash.identifier", defaultValue: "crash"):
            return "🐞"
        case String(localized: "feedback.problem-type.unresponsive.identifier", defaultValue: "unresponsive"):
            return "🐞"
        case String(localized: "feedback.problem-type.suggestions.identifier", defaultValue: "suggestions"):
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "feedback.feedback-type.other.option", defaultValue: "Other", comment: "Option title for other feedback category")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.problem-type.behaviour.identifier", defaultValue: "behaviour"):
            return String(localized: "feedback.feedback-type.bug.label-primary", defaultValue: "Bug", comment: "Primary label for bug feedback type")
        case String(localized: "feedback.problem-type.crash.identifier", defaultValue: "crash"):
            return String(localized: "feedback.feedback-type.bug.label-secondary", defaultValue: "Bug", comment: "Secondary label for bug feedback type")
        case String(localized: "feedback.problem-type.unresponsive.identifier", defaultValue: "unresponsive"):
            return String(localized: "feedback.feedback-type.bug.slug-label", defaultValue: "Bug", comment: "Bug feedback type fallback display value")
        case String(localized: "feedback.problem-type.suggestions.identifier", defaultValue: "suggestions"):
            return String(localized: "feedback.feedback-type.suggestion.label", defaultValue: "Suggestion", comment: "Display label for suggestion feedback type")
        case "other":
            return String(localized: "feedback.model.type.feedback", defaultValue: "Feedback", comment: "Title for generic feedback type")
        default:
            return String(localized: "feedback.model.type.other", defaultValue: "Other", comment: "Title for other feedback type")
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
                localized: "feedback.model.body.markdown",
                defaultValue: "**Description**\n\n%@\n\n        **Steps to Reproduce**\n\n%@\n\n        **What did you expect to happen?**\n\n%@\n\n        **What actually happened?**\n\n%@",
                comment: "Markdown template for feedback issue body with description, steps, expected result, and actual result"
            ),
            description,
            steps ?? "N/A",
            expectation ?? "N/A",
            actuallyHappened ?? "N/A"
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
            title: String(format: String(localized: "feedback.model.issue-title.format", defaultValue: "%@ %@", comment: "Issue title format combining feedback type and feedback title"), "\(getFeedbackTypeTitle())", "\(title)"),
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
