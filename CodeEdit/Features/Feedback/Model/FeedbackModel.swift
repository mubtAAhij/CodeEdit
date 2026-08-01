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
        FeedbackType(name: String(localized: "feedback.type.choose", defaultValue: "Choose...", comment: "Placeholder option for feedback type picker"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect-behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", defaultValue: "Application Crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.slow-unresponsive", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", defaultValue: "Suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", defaultValue: "Other", comment: "Feedback type for other issues"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.select", defaultValue: "Please select the problem area", comment: "Placeholder option for issue area picker"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.area.project-navigator", defaultValue: "Project Navigator", comment: "Issue area for Project Navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.area.extensions", defaultValue: "Extensions", comment: "Issue area for Extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.area.git", defaultValue: "Git", comment: "Issue area for Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.area.debugger", defaultValue: "Debugger", comment: "Issue area for Debugger"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.area.editor", defaultValue: "Editor", comment: "Issue area for Editor"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.area.other", defaultValue: "Other", comment: "Issue area for other"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.label.project-navigator", defaultValue: "Project Navigator", comment: "GitHub label for Project Navigator issues")
        case "extensions":
            return String(localized: "feedback.label.extensions", defaultValue: "Extensions", comment: "GitHub label for Extensions issues")
        case "git":
            return String(localized: "feedback.label.git", defaultValue: "Git", comment: "GitHub label for Git issues")
        case "debugger":
            return String(localized: "feedback.label.debugger", defaultValue: "Debugger", comment: "GitHub label for Debugger issues")
        case "editor":
            return String(localized: "feedback.label.editor", defaultValue: "Editor", comment: "GitHub label for Editor issues")
        case "other":
            return String(localized: "feedback.label.other", defaultValue: "Other", comment: "GitHub label for Other issues")
        default:
            return String(localized: "feedback.label.other", defaultValue: "Other", comment: "GitHub label for Other issues")
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
            return "Other"
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.github-label.bug", defaultValue: "Bug", comment: "GitHub label for bug reports")
        case "crash":
            return String(localized: "feedback.github-label.bug", defaultValue: "Bug", comment: "GitHub label for bug reports")
        case "unresponsive":
            return String(localized: "feedback.github-label.bug", defaultValue: "Bug", comment: "GitHub label for bug reports")
        case "suggestions":
            return String(localized: "feedback.github-label.suggestion", defaultValue: "Suggestion", comment: "GitHub label for suggestions")
        case "other":
            return String(localized: "feedback.github-label.feedback", defaultValue: "Feedback", comment: "GitHub label for general feedback")
        default:
            return String(localized: "feedback.github-label.other", defaultValue: "Other", comment: "GitHub label for other issues")
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
        let naValue = String(localized: "feedback.github-body.na", defaultValue: "N/A", comment: "Not applicable placeholder in issue body")
        let template = String(localized: "feedback.github-body.template", defaultValue: """
        **Description**

        %@

        **Steps to Reproduce**

        %@

        **What did you expect to happen?**

        %@

        **What actually happened?**

        %@
        """, comment: "GitHub issue body template with description, steps, expectation, and actual result")
        return String(format: template, description, steps ?? naValue, expectation ?? naValue, actuallyHappened ?? naValue)
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
