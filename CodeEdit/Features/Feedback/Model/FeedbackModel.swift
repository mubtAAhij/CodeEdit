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
        FeedbackType(name: String(localized: "feedback.type.choose", defaultValue: "Choose...", comment: "Placeholder for feedback type picker"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.incorrect-behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Feedback type for incorrect or unexpected behaviour"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash", defaultValue: "Application Crash", comment: "Feedback type for application crash"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.slow", defaultValue: "Application Slow/Unresponsive", comment: "Feedback type for slow or unresponsive application"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion", defaultValue: "Suggestion", comment: "Feedback type for suggestion"), id: "suggestions"),
        FeedbackType(name: String(localized: "other", defaultValue: "Other", comment: "Other option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.choose", defaultValue: "Please select the problem area", comment: "Placeholder for problem area picker"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.area.project-navigator", defaultValue: "Project Navigator", comment: "Problem area for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.area.extensions", defaultValue: "Extensions", comment: "Problem area for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.area.git", defaultValue: "Git", comment: "Problem area for Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.area.debugger", defaultValue: "Debugger", comment: "Problem area for debugger"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.area.editor", defaultValue: "Editor", comment: "Problem area for editor"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "other", defaultValue: "Other", comment: "Other option"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.area.project-navigator", defaultValue: "Project Navigator", comment: "Problem area for project navigator")
        case "extensions":
            return String(localized: "feedback.area.extensions", defaultValue: "Extensions", comment: "Problem area for extensions")
        case "git":
            return String(localized: "feedback.area.git", defaultValue: "Git", comment: "Problem area for Git")
        case "debugger":
            return String(localized: "feedback.area.debugger", defaultValue: "Debugger", comment: "Problem area for debugger")
        case "editor":
            return String(localized: "feedback.area.editor", defaultValue: "Editor", comment: "Problem area for editor")
        case "other":
            return String(localized: "other", defaultValue: "Other", comment: "Other option")
        default:
            return String(localized: "other", defaultValue: "Other", comment: "Other option")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.emoji.bug", defaultValue: "🐞", comment: "Bug emoji for feedback")
        case "crash":
            return String(localized: "feedback.emoji.bug", defaultValue: "🐞", comment: "Bug emoji for feedback")
        case "unresponsive":
            return String(localized: "feedback.emoji.bug", defaultValue: "🐞", comment: "Bug emoji for feedback")
        case "suggestions":
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "other", defaultValue: "Other", comment: "Other option")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Bug label for feedback")
        case "crash":
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Bug label for feedback")
        case "unresponsive":
            return String(localized: "feedback.label.bug", defaultValue: "Bug", comment: "Bug label for feedback")
        case "suggestions":
            return String(localized: "feedback.label.suggestion", defaultValue: "Suggestion", comment: "Suggestion label for feedback")
        case "other":
            return String(localized: "feedback.label.feedback", defaultValue: "Feedback", comment: "Feedback label")
        default:
            return String(localized: "other", defaultValue: "Other", comment: "Other option")
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
        let naValue = String(localized: "feedback.na", defaultValue: "N/A", comment: "Not applicable placeholder")
        return String(format: NSLocalizedString("feedback.issue-body", comment: "Issue body template for feedback"), description, steps ?? naValue, expectation ?? naValue, actuallyHappened ?? naValue)
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
