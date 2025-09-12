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
        FeedbackType(name: "String(localized: "feedback_choose_placeholder", comment: "Placeholder text for dropdown selection")", id: "none"),
        FeedbackType(name: "String(localized: "incorrect_unexpected_behaviour", comment: "Feedback type for incorrect or unexpected behavior")", id: "behaviour"),
        FeedbackType(name: "String(localized: "application_crash", comment: "Feedback type for application crashes")", id: "crash"),
        FeedbackType(name: "String(localized: "application_slow_unresponsive", comment: "Feedback type for slow or unresponsive application")", id: "unresponsive"),
        FeedbackType(name: "String(localized: "suggestion", comment: "Feedback type for suggestions")", id: "suggestions"),
        FeedbackType(name: "Other", id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: "String(localized: "please_select_problem_area", comment: "Prompt text for selecting problem area in feedback")", id: "none"),
        FeedbackIssueArea(name: "String(localized: "project_navigator", comment: "Issue area label for Project Navigator")", id: "projectNavigator"),
        FeedbackIssueArea(name: "String(localized: "extensions", comment: "Issue area label for Extensions")", id: "extensions"),
        FeedbackIssueArea(name: "String(localized: "git", comment: "Issue area label for Git")", id: "git"),
        FeedbackIssueArea(name: "String(localized: "debugger", comment: "Issue area label for Debugger")", id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: "Other", id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return "String(localized: "project_navigator", comment: "Issue area label for Project Navigator")"
        case "extensions":
            return "String(localized: "extensions", comment: "Issue area label for Extensions")"
        case "git":
            return "String(localized: "git", comment: "Issue area label for Git")"
        case "debugger":
            return "String(localized: "debugger", comment: "Issue area label for Debugger")"
        case "editor":
            return "Editor"
        case "other":
            return "Other"
        default:
            return "Other"
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
            return "String(localized: "feedback_emoji", comment: "Emoji for feedback type")"
        default:
            return "Other"
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return "String(localized: "bug", comment: "Label for bug feedback type")"
        case "crash":
            return "String(localized: "bug", comment: "Label for bug feedback type")"
        case "unresponsive":
            return "String(localized: "bug", comment: "Label for bug feedback type")"
        case "suggestions":
            return "String(localized: "suggestion", comment: "Label for suggestion feedback type")"
        case "other":
            return "String(localized: "feedback", comment: "Label for general feedback type")"
        default:
            return "Other"
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
