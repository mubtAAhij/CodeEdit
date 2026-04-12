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
        FeedbackType(name: String(localized: "feedback.choose", defaultValue: "Choose...", comment: "Choose option"), id: "none"),
        FeedbackType(name: String(localized: "feedback.incorrect-behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Incorrect/Unexpected Behaviour option"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.app-crash", defaultValue: "Application Crash", comment: "Application Crash option"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.app-slow", defaultValue: "Application Slow/Unresponsive", comment: "Application Slow/Unresponsive option"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.suggestion", defaultValue: "Suggestion", comment: "Suggestion option"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.other", defaultValue: "Other", comment: "Other option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.select-problem-area", defaultValue: "Please select the problem area", comment: "Please select the problem area prompt"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.project-navigator", defaultValue: "Project Navigator", comment: "Project Navigator area"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.extensions", defaultValue: "Extensions", comment: "Extensions area"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.git", defaultValue: "Git", comment: "Git area"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.debugger", defaultValue: "Debugger", comment: "Debugger area"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.editor", defaultValue: "Editor", comment: "Editor area"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.other", defaultValue: "Other", comment: "Other option"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.project-navigator", defaultValue: "Project Navigator", comment: "Project Navigator area")
        case "extensions":
            return String(localized: "feedback.extensions", defaultValue: "Extensions", comment: "Extensions area")
        case "git":
            return String(localized: "feedback.git", defaultValue: "Git", comment: "Git area")
        case "debugger":
            return String(localized: "feedback.debugger", defaultValue: "Debugger", comment: "Debugger area")
        case "editor":
            return String(localized: "feedback.editor", defaultValue: "Editor", comment: "Editor area")
        case "other":
            return String(localized: "feedback.other", defaultValue: "Other", comment: "Other option")
        default:
            return String(localized: "feedback.other", defaultValue: "Other", comment: "Other option")
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
            return String(localized: "feedback.bug", defaultValue: "Bug", comment: "Bug label")
        case "crash":
            return String(localized: "feedback.bug", defaultValue: "Bug", comment: "Bug label")
        case "unresponsive":
            return String(localized: "feedback.bug", defaultValue: "Bug", comment: "Bug label")
        case "suggestions":
            return String(localized: "feedback.suggestion", defaultValue: "Suggestion", comment: "Suggestion label")
        case "other":
            return String(localized: "feedback.feedback", defaultValue: "Feedback", comment: "Feedback label")
        default:
            return String(localized: "feedback.other", defaultValue: "Other", comment: "Other label")
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
