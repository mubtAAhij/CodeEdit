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
        FeedbackType(name: String(localized: "feedback.type.choose", defaultValue: "Choose...", comment: "Placeholder title prompting the user to choose a feedback type"), id: "none"),
        FeedbackType(name: String(localized: "feedback.type.behaviour.title", defaultValue: "Incorrect/Unexpected Behaviour", comment: "User-facing feedback category title for incorrect or unexpected behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.type.crash.title", defaultValue: "Application Crash", comment: "User-facing feedback category title for application crash reports"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.type.unresponsive.title", defaultValue: "Application Slow/Unresponsive", comment: "User-facing feedback category title for performance or responsiveness issues"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.type.suggestion.title", defaultValue: "Suggestion", comment: "User-facing feedback category title for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.type.other.title", defaultValue: "Other", comment: "User-facing feedback category title for uncategorized feedback"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.area.select-prompt", defaultValue: "Please select the problem area", comment: "Prompt asking user to select the affected area"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.area.project-navigator", defaultValue: "Project Navigator", comment: "Feedback area option for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.area.extensions", defaultValue: "Extensions", comment: "Feedback area option for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.area.git", defaultValue: "Git", comment: "Feedback area option for Git integration"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.area.debugger", defaultValue: "Debugger", comment: "Feedback area option for debugger"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.area.editor", defaultValue: "Editor", comment: "Feedback area option for editor"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.area.other", defaultValue: "Other", comment: "Feedback area option for other problem areas"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.area.project-navigator.detail", defaultValue: "Project Navigator", comment: "Feedback area value for project navigator in detailed mapping")
        case "extensions":
            return String(localized: "feedback.area.extensions.detail", defaultValue: "Extensions", comment: "Feedback area value for extensions in detailed mapping")
        case "git":
            return String(localized: "feedback.area.git.detail", defaultValue: "Git", comment: "Feedback area value for Git in detailed mapping")
        case "debugger":
            return String(localized: "feedback.area.debugger.detail", defaultValue: "Debugger", comment: "Feedback area value for debugger in detailed mapping")
        case "editor":
            return String(localized: "feedback.area.editor.detail", defaultValue: "Editor", comment: "Feedback area value for editor in detailed mapping")
        case "other":
            return String(localized: "feedback.area.other.detail", defaultValue: "Other", comment: "Feedback area value for other areas in detailed mapping")
        default:
            return String(localized: "feedback.subtype.other", defaultValue: "Other", comment: "Feedback subtype value for uncategorized entries")
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
            return String(localized: "feedback.problem.other", defaultValue: "Other", comment: "Problem area option for other issues")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.kind.bug", defaultValue: "Bug", comment: "Feedback kind option for bug reports")
        case "crash":
            return "Bug"
        case "unresponsive":
            return "Bug"
        case "suggestions":
            return "Suggestion"
        case "other":
            return "Feedback"
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
