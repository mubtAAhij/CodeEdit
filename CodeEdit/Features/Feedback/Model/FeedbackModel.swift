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
        FeedbackType(name: "Choose...", id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect_behavior", comment: "Feedback type for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.performance", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", comment: "Other feedback type option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.select_prompt", comment: "Prompt to select the problem area for feedback"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.area.project_navigator", comment: "Problem area: Project Navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.area.extensions", comment: "Problem area: Extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.area.git", comment: "Problem area: Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.area.debugger", comment: "Problem area: Debugger"), id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.type.other", comment: "Other feedback type label"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.area.project_navigator", comment: "Problem area: Project Navigator")
        case "extensions":
            return String(localized: "feedback.area.extensions", comment: "Problem area: Extensions")
        case "git":
            return String(localized: "feedback.area.git", comment: "Problem area: Git")
        case "debugger":
            return String(localized: "feedback.area.debugger", comment: "Problem area: Debugger")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "feedback.area.other", comment: "Problem area: Other")
        default:
            return String(localized: "feedback.area.other", comment: "Problem area: Other")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji for feedback type")
        case "crash":
            return String(localized: "feedback.type.bug_emoji", comment: "Bug emoji for feedback type")
        case "unresponsive":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji for feedback type")
        case "suggestions":
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "feedback.area.other", comment: "Problem area: Other")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.type.bug", comment: "Bug feedback type label")
        case "crash":
            return "Bug"
        case "unresponsive":
            return String(localized: "feedback.type.bug", comment: "Bug feedback type label")
        case "suggestions":
            return String(localized: "feedback.type.suggestion", comment: "Suggestion feedback type label")
        case "other":
            return String(localized: "feedback.type.feedback", comment: "Feedback type label")
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

        \(steps ?? String(localized: "feedback.na", comment: "N/A placeholder for feedback"))

        **What did you expect to happen?**

        \(expectation ?? "N/A")

        **What actually happened?**

        \(actuallyHappened ?? String(localized: "feedback.na", comment: "N/A placeholder for feedback"))
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
