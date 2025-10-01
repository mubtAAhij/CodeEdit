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
        FeedbackType(name: String(localized: "feedback.type.choose_placeholder", comment: "Placeholder text for feedback type selection"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect_behavior", comment: "Feedback type for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.slow_unresponsive", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", comment: "Other feedback type option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.select_placeholder", comment: "Placeholder text for problem area selection"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.project_navigator", comment: "Feedback issue area for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.extensions", comment: "Feedback issue area for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.git", comment: "Feedback issue area for Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.debugger", comment: "Feedback issue area for debugger"), id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.type.other", comment: "Other feedback type option"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.issue_area.project_navigator", comment: "Feedback issue area for project navigator")
        case "extensions":
            return String(localized: "feedback.issue_area.extensions", comment: "Feedback issue area for extensions")
        case "git":
            return String(localized: "feedback.issue_area.git", comment: "Feedback issue area for Git")
        case "debugger":
            return String(localized: "feedback.issue_area.debugger", comment: "Feedback issue area for debugger")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "feedback.type.other", comment: "Other feedback type option")
        default:
            return String(localized: "feedback.type.other", comment: "Other feedback type option")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji for feedback")
        case "crash":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji for feedback")
        case "unresponsive":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji for feedback")
        case "suggestions":
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "feedback.type.other", comment: "Other feedback type option")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.type.bug", comment: "Bug feedback type label")
        case "crash":
            return String(localized: "feedback.type.bug", comment: "Bug feedback type label")
        case "unresponsive":
            return String(localized: "feedback.type.bug", comment: "Bug feedback type label")
        case "suggestions":
            return String(localized: "feedback.type.suggestion", comment: "Feedback type for suggestions")
        case "other":
            return String(localized: "feedback.type.feedback", comment: "General feedback type label")
        default:
            return String(localized: "feedback.type.other", comment: "Other feedback type option")
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
        String(localized: "feedback.issue_body_template", arguments: [description, steps ?? String(localized: "feedback.not_applicable", comment: "Not applicable"), expectation ?? String(localized: "feedback.not_applicable", comment: "Not applicable"), actuallyHappened ?? String(localized: "feedback.not_applicable", comment: "Not applicable")], comment: "Issue body template with description, steps, expectation, and what happened")
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
