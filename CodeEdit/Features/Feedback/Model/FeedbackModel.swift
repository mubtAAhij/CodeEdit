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
        FeedbackType(name: String(localized: "feedback.type.choose", defaultValue: "Choose...", comment: "Placeholder text for feedback type selection"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", defaultValue: "Application Crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.unresponsive", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", defaultValue: "Suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", defaultValue: "Other", comment: "Feedback type for other issues"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.choose", defaultValue: "Please select the problem area", comment: "Placeholder text for issue area selection"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.project-navigator", defaultValue: "Project Navigator", comment: "Issue area label for project navigator-related problems"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.extensions", defaultValue: "Extensions", comment: "Issue area label for extension-related problems"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.git", defaultValue: "Git", comment: "Issue area label for git-related problems"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.debugger", defaultValue: "Debugger", comment: "Issue area label for debugger-related problems"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.editor", defaultValue: "Editor", comment: "Issue area label for editor-related problems"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.issue-area.other", defaultValue: "Other", comment: "Issue area label for other problems"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.issue-label.project-navigator", defaultValue: "Project Navigator", comment: "GitHub issue label for project navigator issues")
        case "extensions":
            return String(localized: "feedback.issue-label.extensions", defaultValue: "Extensions", comment: "GitHub issue label for extension issues")
        case "git":
            return String(localized: "feedback.issue-label.git", defaultValue: "Git", comment: "GitHub issue label for git issues")
        case "debugger":
            return String(localized: "feedback.issue-label.debugger", defaultValue: "Debugger", comment: "GitHub issue label for debugger issues")
        case "editor":
            return String(localized: "feedback.issue-label.editor", defaultValue: "Editor", comment: "GitHub issue label for editor issues")
        case "other":
            return String(localized: "feedback.issue-label.other", defaultValue: "Other", comment: "GitHub issue label for other issues")
        default:
            return String(localized: "feedback.issue-label.other", defaultValue: "Other", comment: "GitHub issue label for other issues")
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
            return String(localized: "feedback.type-title.other", defaultValue: "Other", comment: "Default feedback type title")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.type-label.bug", defaultValue: "Bug", comment: "GitHub issue label for bug reports")
        case "crash":
            return String(localized: "feedback.type-label.bug", defaultValue: "Bug", comment: "GitHub issue label for bug reports")
        case "unresponsive":
            return String(localized: "feedback.type-label.bug", defaultValue: "Bug", comment: "GitHub issue label for bug reports")
        case "suggestions":
            return String(localized: "feedback.type-label.suggestion", defaultValue: "Suggestion", comment: "GitHub issue label for suggestions")
        case "other":
            return String(localized: "feedback.type-label.feedback", defaultValue: "Feedback", comment: "GitHub issue label for general feedback")
        default:
            return String(localized: "feedback.type-label.other", defaultValue: "Other", comment: "GitHub issue label for other feedback types")
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
        let descriptionLabel = String(localized: "feedback.issue-body.description", defaultValue: "Description", comment: "Label for issue description section")
        let stepsLabel = String(localized: "feedback.issue-body.steps", defaultValue: "Steps to Reproduce", comment: "Label for steps to reproduce section")
        let expectationLabel = String(localized: "feedback.issue-body.expectation", defaultValue: "What did you expect to happen?", comment: "Label for expectation section")
        let actualLabel = String(localized: "feedback.issue-body.actual", defaultValue: "What actually happened?", comment: "Label for actual behavior section")
        let notApplicable = String(localized: "feedback.issue-body.not-applicable", defaultValue: "N/A", comment: "Not applicable text for empty sections")

        return """
        **\(descriptionLabel)**

        \(description)

        **\(stepsLabel)**

        \(steps ?? notApplicable)

        **\(expectationLabel)**

        \(expectation ?? notApplicable)

        **\(actualLabel)**

        \(actuallyHappened ?? notApplicable)
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
