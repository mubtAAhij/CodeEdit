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
        FeedbackType(name: String(localized: "feedback.type.choose", comment: "Default option to choose feedback type"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect_behavior", comment: "Feedback type for incorrect behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", comment: "Feedback type for application crashes"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.slow", comment: "Feedback type for slow/unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", comment: "Other feedback type option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.select", comment: "Default option to select problem area"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.project_navigator", comment: "Project Navigator issue area label"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.extensions", comment: "Extensions issue area label"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.git", comment: "Git issue area label"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.debugger", comment: "Debugger issue area label"), id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.issue_area.other", comment: "Other issue area label"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.issue_area.project_navigator", comment: "Project Navigator issue area label")
        case "extensions":
            return String(localized: "feedback.issue_area.extensions", comment: "Extensions issue area label")
        case "git":
            return String(localized: "feedback.issue_area.git", comment: "Git issue area label")
        case "debugger":
            return String(localized: "feedback.issue_area.debugger", comment: "Debugger issue area label")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "feedback.issue_area.other", comment: "Other issue area label")
        default:
            return String(localized: "feedback.issue_area.other", comment: "Other issue area label")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.type.bug_emoji", comment: "Bug emoji for feedback type")
        case "crash":
            return String(localized: "feedback.type.bug_emoji", comment: "Bug emoji for feedback type")
        case "unresponsive":
            return String(localized: "feedback.type.bug_emoji", comment: "Bug emoji for feedback type")
        case "suggestions":
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "feedback.issue_area.other", comment: "Other issue area label")
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
            return String(localized: "feedback.type.suggestion", comment: "Suggestion feedback type label")
        case "other":
            return String(localized: "feedback.type.feedback", comment: "Feedback type label")
        default:
            return String(localized: "feedback.issue_area.other", comment: "Other issue area option")
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
        String(localized: "feedback.issue_body_template", arguments: [description, steps ?? String(localized: "feedback.not_applicable", comment: "N/A placeholder"), expectation ?? String(localized: "feedback.not_applicable", comment: "N/A placeholder"), actuallyHappened ?? String(localized: "feedback.not_applicable", comment: "N/A placeholder")], comment: "Template for GitHub issue body with description, steps, expectation, and actual result")
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
