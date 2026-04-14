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
        FeedbackType(name: String(localized: "choose", defaultValue: "Choose...", comment: "Choose feedback type option"), id: "none"),
        FeedbackType(name: String(localized: "incorrect-unexpected-behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Incorrect/unexpected behaviour feedback type", os_id: "102023"), id: "behaviour"),
        FeedbackType(name: String(localized: "application-crash", defaultValue: "Application Crash", comment: "Application crash feedback type", os_id: "102024"), id: "crash"),
        FeedbackType(name: String(localized: "application-slow-unresponsive", defaultValue: "Application Slow/Unresponsive", comment: "Application slow/unresponsive feedback type", os_id: "102025"), id: "unresponsive"),
        FeedbackType(name: String(localized: "suggestion", defaultValue: "Suggestion", comment: "Suggestion feedback type"), id: "suggestions"),
        FeedbackType(name: String(localized: "other", defaultValue: "Other", comment: "Other feedback type"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "select-problem-area", defaultValue: "Please select the problem area", comment: "Select problem area option", os_id: "102028"), id: "none"),
        FeedbackIssueArea(name: String(localized: "project-navigator", defaultValue: "Project Navigator", comment: "Project navigator issue area"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "extensions", defaultValue: "Extensions", comment: "Extensions issue area"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "git", defaultValue: "Git", comment: "Git issue area"), id: "git"),
        FeedbackIssueArea(name: String(localized: "debugger", defaultValue: "Debugger", comment: "Debugger issue area"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "editor", defaultValue: "Editor", comment: "Editor issue area"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "other", defaultValue: "Other", comment: "Other issue area"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "project-navigator", defaultValue: "Project Navigator", comment: "Project navigator label")
        case "extensions":
            return String(localized: "extensions", defaultValue: "Extensions", comment: "Extensions label")
        case "git":
            return String(localized: "git", defaultValue: "Git", comment: "Git label")
        case "debugger":
            return String(localized: "debugger", defaultValue: "Debugger", comment: "Debugger label", os_id: "102031")
        case "editor":
            return String(localized: "editor", defaultValue: "Editor", comment: "Editor label")
        case "other":
            return String(localized: "other", defaultValue: "Other", comment: "Other label")
        default:
            return String(localized: "other", defaultValue: "Other", comment: "Other default label")
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
            return String(localized: "other", defaultValue: "Other", comment: "Other feedback type title")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "bug", defaultValue: "Bug", comment: "Bug feedback label")
        case "crash":
            return String(localized: "bug", defaultValue: "Bug", comment: "Bug feedback label")
        case "unresponsive":
            return String(localized: "bug", defaultValue: "Bug", comment: "Bug feedback label", os_id: "102033")
        case "suggestions":
            return String(localized: "suggestion", defaultValue: "Suggestion", comment: "Suggestion feedback label", os_id: "102026")
        case "other":
            return String(localized: "feedback", defaultValue: "Feedback", comment: "Feedback label", os_id: "102034")
        default:
            return String(localized: "other", defaultValue: "Other", comment: "Other feedback label", os_id: "102027")
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
