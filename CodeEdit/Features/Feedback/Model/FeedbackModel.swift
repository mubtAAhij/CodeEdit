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
        FeedbackType(name: String(localized: "feedback.type.choose", comment: "Feedback type placeholder"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect_behaviour", comment: "Feedback type option"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", comment: "Feedback type option"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.slow_unresponsive", comment: "Feedback type option"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", comment: "Feedback type option"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other", comment: "Feedback type option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.select", comment: "Issue area placeholder"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.area.project_navigator", comment: "Issue area option"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.area.extensions", comment: "Issue area option"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.area.git", comment: "Issue area option"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.area.debugger", comment: "Issue area option"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.area.editor", comment: "Issue area option"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.area.other", comment: "Issue area option"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.label.project_navigator", comment: "Issue label")
        case "extensions":
            return String(localized: "feedback.label.extensions", comment: "Issue label")
        case "git":
            return String(localized: "feedback.label.git", comment: "Issue label")
        case "debugger":
            return String(localized: "feedback.label.debugger", comment: "Issue label")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "feedback.label.other", comment: "Issue label")
        default:
            return String(localized: "feedback.label.other", comment: "Issue label")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji")
        case "crash":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji")
        case "unresponsive":
            return String(localized: "feedback.emoji.bug.unresponsive", comment: "Bug emoji")
        case "suggestions":
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "feedback.emoji.other", comment: "Other emoji")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.label.bug", comment: "Bug label")
        case "crash":
            return String(localized: "feedback.label.bug.crash", comment: "Bug label")
        case "unresponsive":
            return String(localized: "feedback.label.bug.unresponsive", comment: "Bug label")
        case "suggestions":
            return String(localized: "feedback.label.suggestion", comment: "Suggestion label")
        case "other":
            return String(localized: "feedback.label.feedback", comment: "Feedback label")
        default:
            return String(localized: "feedback.label.other.default", comment: "Other label")
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
        String(localized: "feedback.issue.body \(description) \(steps ?? String(localized: "feedback.na", comment: "N/A text")) \(expectation ?? String(localized: "feedback.na", comment: "N/A text")) \(actuallyHappened ?? String(localized: "feedback.na", comment: "N/A text"))", comment: "Issue body template")
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
