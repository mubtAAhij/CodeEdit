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
        FeedbackType(name: String(
            localized: "feedback-model.type.choose",
            defaultValue: "Choose...",
            comment: "Placeholder for feedback type selection"
        ), id: "none"),
        FeedbackType(name: String(
            localized: "feedback-model.type.incorrect-behaviour",
            defaultValue: "Incorrect/Unexpected Behaviour",
            comment: "Feedback type for incorrect or unexpected behavior"
        ), id: "behaviour"),
        FeedbackType(name: String(
            localized: "feedback-model.type.crash",
            defaultValue: "Application Crash",
            comment: "Feedback type for application crashes"
        ), id: "crash"),
        FeedbackType(name: String(
            localized: "feedback-model.type.slow-unresponsive",
            defaultValue: "Application Slow/Unresponsive",
            comment: "Feedback type for slow or unresponsive application"
        ), id: "unresponsive"),
        FeedbackType(name: String(
            localized: "feedback-model.type.suggestion",
            defaultValue: "Suggestion",
            comment: "Feedback type for suggestions"
        ), id: "suggestions"),
        FeedbackType(name: String(
            localized: "feedback-model.type.other",
            defaultValue: "Other",
            comment: "Feedback type for other issues"
        ), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(
            localized: "feedback-model.area.please-select",
            defaultValue: "Please select the problem area",
            comment: "Placeholder for issue area selection"
        ), id: "none"),
        FeedbackIssueArea(name: String(
            localized: "feedback-model.area.project-navigator",
            defaultValue: "Project Navigator",
            comment: "Issue area for project navigator"
        ), id: "projectNavigator"),
        FeedbackIssueArea(name: String(
            localized: "feedback-model.area.extensions",
            defaultValue: "Extensions",
            comment: "Issue area for extensions"
        ), id: "extensions"),
        FeedbackIssueArea(name: String(
            localized: "feedback-model.area.git",
            defaultValue: "Git",
            comment: "Issue area for Git functionality"
        ), id: "git"),
        FeedbackIssueArea(name: String(
            localized: "feedback-model.area.debugger",
            defaultValue: "Debugger",
            comment: "Issue area for debugger"
        ), id: "debugger"),
        FeedbackIssueArea(name: String(
            localized: "feedback-model.area.editor",
            defaultValue: "Editor",
            comment: "Issue area for editor"
        ), id: "editor"),
        FeedbackIssueArea(name: String(
            localized: "feedback-model.area.other",
            defaultValue: "Other",
            comment: "Issue area for other problems"
        ), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(
                localized: "feedback-model.label.project-navigator",
                defaultValue: "Project Navigator",
                comment: "Label for project navigator issue area"
            )
        case "extensions":
            return String(
                localized: "feedback-model.label.extensions",
                defaultValue: "Extensions",
                comment: "Label for extensions issue area"
            )
        case "git":
            return String(
                localized: "feedback-model.label.git",
                defaultValue: "Git",
                comment: "Label for Git issue area"
            )
        case "debugger":
            return String(
                localized: "feedback-model.label.debugger",
                defaultValue: "Debugger",
                comment: "Label for debugger issue area"
            )
        case "editor":
            return String(
                localized: "feedback-model.label.editor",
                defaultValue: "Editor",
                comment: "Label for editor issue area"
            )
        case "other":
            return String(
                localized: "feedback-model.label.other",
                defaultValue: "Other",
                comment: "Label for other issue area"
            )
        default:
            return String(
                localized: "feedback-model.label.other-default",
                defaultValue: "Other",
                comment: "Default label for unrecognized issue area"
            )
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(
                localized: "feedback-model.emoji.bug-behaviour",
                defaultValue: "🐞",
                comment: "Bug emoji for behaviour feedback"
            )
        case "crash":
            return String(
                localized: "feedback-model.emoji.bug-crash",
                defaultValue: "🐞",
                comment: "Bug emoji for crash feedback"
            )
        case "unresponsive":
            return String(
                localized: "feedback-model.emoji.bug-unresponsive",
                defaultValue: "🐞",
                comment: "Bug emoji for unresponsive feedback"
            )
        case "suggestions":
            return String(
                localized: "feedback-model.emoji.suggestion",
                defaultValue: "✨",
                comment: "Sparkles emoji for suggestion feedback"
            )
        case "other":
            return String(
                localized: "feedback-model.emoji.other",
                defaultValue: "📬",
                comment: "Mailbox emoji for other feedback"
            )
        default:
            return String(
                localized: "feedback-model.emoji.default",
                defaultValue: "Other",
                comment: "Default text for unknown feedback type"
            )
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(
                localized: "feedback-model.label.bug",
                defaultValue: "Bug",
                comment: "Label for bug feedback type"
            )
        case "crash":
            return String(
                localized: "feedback-model.label.bug",
                defaultValue: "Bug",
                comment: "Label for bug feedback type"
            )
        case "unresponsive":
            return String(
                localized: "feedback-model.label.bug",
                defaultValue: "Bug",
                comment: "Label for bug feedback type"
            )
        case "suggestions":
            return String(
                localized: "feedback-model.label.suggestion",
                defaultValue: "Suggestion",
                comment: "Label for suggestion feedback type"
            )
        case "other":
            return String(
                localized: "feedback-model.label.feedback",
                defaultValue: "Feedback",
                comment: "Label for general feedback type"
            )
        default:
            return String(
                localized: "feedback-model.label.other",
                defaultValue: "Other",
                comment: "Label for other feedback type"
            )
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
        let naValue = String(
            localized: "feedback-model.issue-body.not-applicable",
            defaultValue: "N/A",
            comment: "Not applicable placeholder for empty fields"
        )
        let stepsValue = steps ?? naValue
        let expectationValue = expectation ?? naValue
        let actuallyHappenedValue = actuallyHappened ?? naValue

        return String(
            localized: "feedback-model.issue-body.template",
            defaultValue: """
            **Description**

            \(description)

            **Steps to Reproduce**

            \(stepsValue)

            **What did you expect to happen?**

            \(expectationValue)

            **What actually happened?**

            \(actuallyHappenedValue)
            """,
            comment: "Template for GitHub issue body with description, steps, expectation, and actual result"
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
