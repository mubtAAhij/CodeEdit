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
        FeedbackType(name: String(localized: "feedback.problem-area.choose", defaultValue: "Choose...", comment: "Placeholder option text for selecting a feedback problem area."), id: "none"),
        FeedbackType(name: String(localized: "feedback.problem-area.incorrect-unexpected-behaviour.title", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Title for feedback category about incorrect or unexpected behaviour."), id: String(localized: "feedback.problem-area.incorrect-unexpected-behaviour.slug", defaultValue: "behaviour", comment: "Short keyword for incorrect or unexpected behaviour feedback category.")),
        FeedbackType(name: String(localized: "feedback.problem-area.application-crash.title", defaultValue: "Application Crash", comment: "Title for feedback category about application crashes."), id: String(localized: "feedback.problem-area.application-crash.slug", defaultValue: "crash", comment: "Short keyword for application crash feedback category.")),
        FeedbackType(name: String(localized: "feedback.problem-area.application-slow-unresponsive.title", defaultValue: "Application Slow/Unresponsive", comment: "Title for feedback category about slow or unresponsive application behavior."), id: String(localized: "feedback.problem-area.application-slow-unresponsive.slug", defaultValue: "unresponsive", comment: "Short keyword for slow or unresponsive application feedback category.")),
        FeedbackType(name: String(localized: "feedback.problem-area.suggestion.title", defaultValue: "Suggestion", comment: "Title for feedback category suggesting improvements."), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.problem-area.other.title", defaultValue: "Other", comment: "Title for feedback category for uncategorized issues."), id: "other"),
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.validation.select-problem-area", defaultValue: "Please select the problem area", comment: "Validation message shown when no feedback problem area is selected."), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.project-navigator", defaultValue: "Project Navigator", comment: "Problem area option for project navigator issues."), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.extensions", defaultValue: "Extensions", comment: "Problem area option for extensions issues."), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.git", defaultValue: "Git", comment: "Problem area option for Git issues."), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.debugger", defaultValue: "Debugger", comment: "Problem area option for debugger issues."), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.editor", defaultValue: "Editor", comment: "Problem area option for editor issues."), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.problem-area.category.other", defaultValue: "Other", comment: "Problem area option for uncategorized issues."), id: "other"),
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.problem-area.search-key.project-navigator", defaultValue: "Project Navigator", comment: "Search keyword for project navigator problem area.")
        case "extensions":
            return String(localized: "feedback.problem-area.search-key.extensions", defaultValue: "Extensions", comment: "Search keyword for extensions problem area.")
        case "git":
            return String(localized: "feedback.problem-area.search-key.git", defaultValue: "Git", comment: "Search keyword for Git problem area.")
        case "debugger":
            return String(localized: "feedback.problem-area.search-key.debugger", defaultValue: "Debugger", comment: "Search keyword for debugger problem area.")
        case String(localized: "feedback.problem-area.search-key.editor-lowercase", defaultValue: "editor", comment: "Lowercase search keyword for editor problem area."):
            return String(localized: "feedback.problem-area.display.editor", defaultValue: "Editor", comment: "Display label for editor problem area.")
        case "other":
            return String(localized: "feedback.problem-area.display.other", defaultValue: "Other", comment: "Display label for other problem area.")
        default:
            return String(localized: "feedback.problem-area.search-key.other", defaultValue: "Other", comment: "Search keyword for other problem area.")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return "🐞"
        case String(localized: "feedback.issue-type.crash.keyword", defaultValue: "crash", comment: "Keyword for crash issue type."):
            return "🐞"
        case String(localized: "feedback.issue-type.unresponsive.keyword", defaultValue: "unresponsive", comment: "Keyword for unresponsive issue type."):
            return "🐞"
        case String(localized: "feedback.issue-type.suggestions.keyword", defaultValue: "suggestions", comment: "Keyword for suggestions issue type."):
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "feedback.issue-type.other", defaultValue: "Other", comment: "Issue type label for uncategorized feedback.")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.issue-type.bug.title", defaultValue: "Bug", comment: "Title label for bug issue type.")
        case "crash":
            return String(localized: "feedback.issue-type.bug.keyword", defaultValue: "Bug", comment: "Keyword label for bug issue type.")
        case "unresponsive":
            return String(localized: "feedback.issue-type.bug.label", defaultValue: "Bug", comment: "Label for bug issue type in feedback model.")
        case "suggestions":
            return "Suggestion"
        case "other":
            return String(localized: "feedback.issue-type.feedback.label", defaultValue: "Feedback", comment: "Label for feedback issue type in feedback model.")
        default:
            return String(localized: "feedback.issue-type.other.label", defaultValue: "Other", comment: "Label for other issue type in feedback model.")
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

        \(steps ?? String(localized: "feedback.optional-field.not-applicable.primary", defaultValue: "N/A", comment: "Not applicable fallback value for optional feedback field."))

        **What did you expect to happen?**

        \(expectation ?? String(localized: "feedback.optional-field.not-applicable.secondary", defaultValue: "N/A", comment: "Not applicable fallback value for optional feedback field in alternate context."))

        **What actually happened?**

        \(actuallyHappened ?? String(localized: "feedback.optional-field.not-applicable.tertiary", defaultValue: "N/A", comment: "Not applicable fallback value for optional feedback field in tertiary context."))
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
            case let .success(issue):
                if Settings[\.sourceControl].general.openFeedbackInBrowser {
                    self.openIssueURL(issue.htmlURL ?? URL(string: "https://github.com/CodeEditApp/CodeEdit/issues")!)
                }
                self.isSubmitted.toggle()
                print(issue)
            case let .failure(error):
                self.failedToSubmit.toggle()
                print(error)
            }
        }
    }
}
