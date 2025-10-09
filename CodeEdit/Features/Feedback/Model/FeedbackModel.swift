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
        FeedbackType(name: String(localized: "feedback.type.choose", comment: "Default choice option in feedback type selection"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect_behavior", comment: "Feedback type for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.unresponsive", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", comment: "Other feedback type option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.select_prompt", comment: "Prompt to select problem area in feedback"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.area.project_navigator", comment: "Project Navigator feedback area"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.area.extensions", comment: "Extensions feedback area"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.area.git", comment: "Git feedback area"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.area.debugger", comment: "Debugger feedback area"), id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.area.other", comment: "Other feedback area option"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.area.project_navigator", comment: "Project Navigator feedback area")
        case "extensions":
            return String(localized: "feedback.area.extensions", comment: "Extensions feedback area")
        case "git":
            return String(localized: "feedback.area.git", comment: "Git feedback area")
        case "debugger":
            return String(localized: "feedback.area.debugger", comment: "Debugger feedback area")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "feedback.area.other", comment: "Other feedback area option")
        default:
            return String(localized: "feedback.type.other", comment: "Other feedback type")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji for feedback types")
        case "crash":
            return String(localized: "feedback.type.bug.icon", comment: "Bug emoji icon for feedback type")
        case "unresponsive":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji for feedback types")
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
            return String(localized: "feedback.type.bug", comment: "Bug feedback type")
        case "crash":
            return String(localized: "feedback.type.bug", comment: "Bug feedback type")
        case "unresponsive":
            return String(localized: "feedback.type.bug", comment: "Bug feedback type")
        case "suggestions":
            return String(localized: "feedback.type.suggestion", comment: "Suggestion feedback type")
        case "other":
            return String(localized: "feedback.type.feedback", comment: "General feedback type")
        default:
            return String(localized: "feedback.type.other", comment: "Other feedback type")
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

        \(steps ?? String(localized: "feedback.not_applicable", comment: "Not applicable placeholder"))

        **What did you expect to happen?**

        \(expectation ?? String(localized: "feedback.not_applicable", comment: "Not applicable placeholder"))

        **What actually happened?**

        \(actuallyHappened ?? String(localized: "feedback.not_applicable", comment: "Not applicable placeholder"))
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
