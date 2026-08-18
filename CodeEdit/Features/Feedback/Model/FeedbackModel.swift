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
        FeedbackType(name: String(localized: "feedback.model.feedback-type.choose", defaultValue: "Choose...", comment: "Picker placeholder for selecting feedback type"), id: "none"),
        FeedbackType(name: String(localized: "feedback.model.feedback-type.incorrect-unexpected-behaviour.title", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type option for incorrect or unexpected behavior"), id: String(localized: "feedback.model.feedback-type.incorrect-unexpected-behaviour.token", defaultValue: "behaviour", comment: "Internal feedback type token shown in model for incorrect behavior category")),
        FeedbackType(name: String(localized: "feedback.model.feedback-type.application-crash.title", defaultValue: "Application Crash", comment: "Feedback type option for application crashes"), id: String(localized: "feedback.model.feedback-type.application-crash.token", defaultValue: "crash", comment: "Internal feedback type token shown in model for crash category")),
        FeedbackType(name: String(localized: "feedback.model.feedback-type.application-slow-unresponsive.title", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type option for performance and responsiveness issues"), id: String(localized: "feedback.model.feedback-type.application-slow-unresponsive.token", defaultValue: "unresponsive", comment: "Internal feedback type token shown in model for unresponsive category")),
        FeedbackType(name: String(localized: "feedback.model.feedback-type.suggestion.title", defaultValue: "Suggestion", comment: "Feedback type option for suggestions"), id: String(localized: "feedback.model.feedback-type.suggestion.token", defaultValue: "suggestions", comment: "Internal feedback type token shown in model for suggestions category")),
        FeedbackType(name: String(localized: "feedback.model.feedback-type.other", defaultValue: "Other", comment: "Feedback type option for uncategorized issues"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.model.problem-area.select-prompt", defaultValue: "Please select the problem area", comment: "Prompt text for selecting problem area"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.model.problem-area.project-navigator.title", defaultValue: "Project Navigator", comment: "Problem area option for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.model.problem-area.extensions.title", defaultValue: "Extensions", comment: "Problem area option for extensions"), id: String(localized: "feedback.model.problem-area.extensions.token", defaultValue: "extensions", comment: "Internal problem area token shown in model for extensions")),
        FeedbackIssueArea(name: String(localized: "feedback.model.problem-area.git.title", defaultValue: "Git", comment: "Problem area option for git"), id: String(localized: "feedback.model.problem-area.git.token", defaultValue: "git", comment: "Internal problem area token shown in model for git")),
        FeedbackIssueArea(name: String(localized: "feedback.model.problem-area.debugger.title", defaultValue: "Debugger", comment: "Problem area option for debugger"), id: String(localized: "feedback.model.problem-area.debugger.token", defaultValue: "debugger", comment: "Internal problem area token shown in model for debugger")),
        FeedbackIssueArea(name: String(localized: "feedback.model.problem-area.editor.title", defaultValue: "Editor", comment: "Problem area option for editor"), id: String(localized: "feedback.model.problem-area.editor.token", defaultValue: "editor", comment: "Internal problem area token shown in model for editor")),
        FeedbackIssueArea(name: String(localized: "feedback.model.problem-area.other.title", defaultValue: "Other", comment: "Problem area option title for uncategorized area"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.model.problem-area.project-navigator.secondary-title", defaultValue: "Project Navigator", comment: "Problem area title for project navigator in secondary mapping")
        case String(localized: "feedback.model.problem-area.extensions.secondary-token", defaultValue: "extensions", comment: "Internal token for extensions in secondary mapping"):
            return String(localized: "feedback.model.problem-area.extensions.secondary-title", defaultValue: "Extensions", comment: "Problem area title for extensions in secondary mapping")
        case String(localized: "feedback.model.problem-area.git.secondary-token", defaultValue: "git", comment: "Internal token for git in secondary mapping"):
            return String(localized: "feedback.model.problem-area.git.secondary-title", defaultValue: "Git", comment: "Problem area title for git in secondary mapping")
        case String(localized: "feedback.model.problem-area.debugger.secondary-token", defaultValue: "debugger", comment: "Internal token for debugger in secondary mapping"):
            return String(localized: "feedback.model.problem-area.debugger.secondary-title", defaultValue: "Debugger", comment: "Problem area title for debugger in secondary mapping")
        case String(localized: "feedback.model.problem-area.editor.secondary-token", defaultValue: "editor", comment: "Internal token for editor in secondary mapping"):
            return String(localized: "feedback.model.problem-area.editor.secondary-title", defaultValue: "Editor", comment: "Problem area title for editor in secondary mapping")
        case String(localized: "feedback.model.github-label.other", defaultValue: "other"):
            return String(localized: "feedback.model.problem-area.other.secondary-title", defaultValue: "Other", comment: "Problem area title for other category in secondary mapping")
        default:
            return String(localized: "feedback.model.problem-area.other.fallback-title", defaultValue: "Other", comment: "Fallback problem area title for other category")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.model.feedback-type.behaviour.secondary-token", defaultValue: "behaviour", comment: "Internal token for behaviour feedback type in secondary mapping"):
            return "🐞"
        case String(localized: "feedback.model.feedback-type.crash.secondary-token", defaultValue: "crash", comment: "Internal token for crash feedback type in secondary mapping"):
            return "🐞"
        case String(localized: "feedback.model.feedback-type.unresponsive.secondary-token", defaultValue: "unresponsive", comment: "Internal token for unresponsive feedback type in secondary mapping"):
            return "🐞"
        case String(localized: "feedback.model.feedback-type.suggestions.secondary-token", defaultValue: "suggestions", comment: "Internal token for suggestions feedback type in secondary mapping"):
            return "✨"
        case String(localized: "feedback.model.github-label.other", defaultValue: "other"):
            return "📬"
        default:
            return String(localized: "feedback.model.feedback-type.other.secondary-title", defaultValue: "Other", comment: "Fallback feedback type title for other category")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case String(localized: "feedback.model.github-label.behaviour", defaultValue: "behaviour", comment: "GitHub label token for behaviour issue type"):
            return String(localized: "feedback.model.github-label.bug", defaultValue: "Bug", comment: "GitHub label token for bug issue type")
        case String(localized: "feedback.model.github-label.crash", defaultValue: "crash", comment: "GitHub label token for crash issue type"):
            return String(localized: "feedback.model.github-label.bug.secondary", defaultValue: "Bug", comment: "GitHub label token for bug issue type in secondary mapping")
        case String(localized: "feedback.model.github-label.unresponsive", defaultValue: "unresponsive", comment: "GitHub label token for unresponsive issue type"):
            return String(localized: "feedback.model.feedback-type.bug.title", defaultValue: "Bug", comment: "Feedback type title for bug category")
        case String(localized: "feedback.model.github-label.suggestions", defaultValue: "suggestions", comment: "GitHub label token for suggestions issue type"):
            return String(localized: "feedback.model.feedback-type.suggestion.secondary-title", defaultValue: "Suggestion", comment: "Feedback type title for suggestion category in secondary mapping")
        case String(localized: "feedback.model.github-label.other", defaultValue: "other", comment: "GitHub label token for other issue type"):
            return String(localized: "feedback.model.feedback-type.feedback.title", defaultValue: "Feedback", comment: "Feedback type title for generic feedback category")
        default:
            return String(localized: "feedback.model.feedback-type.other.tertiary-title", defaultValue: "Other", comment: "Feedback type title for other category in tertiary mapping")
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
                localized: "feedback.model.issue-body.template",
                defaultValue: "**Description**\n\n        %@\n\n        **Steps to Reproduce**\n\n        %@\n\n        **What did you expect to happen?**\n\n        %@\n\n        **What actually happened?**\n\n        %@",
                comment: "GitHub issue body template with placeholders for description, steps, expectation, and actual result"
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
            title: String(format: String(localized: "feedback.model.issue-title.formatted", defaultValue: "%@ %@", comment: "Formatted issue title combining feedback type and user-provided title"), "\(getFeedbackTypeTitle())", "\(title)"),
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
