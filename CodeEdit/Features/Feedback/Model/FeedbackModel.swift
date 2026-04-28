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
        FeedbackType(name: String(localized: "feedback-model.choose", defaultValue: "Choose...", comment: "Choose feedback type option"), id: "none"),
        FeedbackType(name: String(localized: "feedback-model.incorrect-behaviour", defaultValue: "Incorrect/Unexpected Behaviour", comment: "Incorrect/unexpected behaviour feedback type"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback-model.application-crash", defaultValue: "Application Crash", comment: "Application crash feedback type"), id: "crash"),
        FeedbackType(name: String(localized: "feedback-model.application-slow", defaultValue: "Application Slow/Unresponsive", comment: "Application slow/unresponsive feedback type"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback-model.suggestion", defaultValue: "Suggestion", comment: "Suggestion feedback type"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback-model.other-type", defaultValue: "Other", comment: "Other feedback type"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback-model.select-problem-area", defaultValue: "Please select the problem area", comment: "Select problem area placeholder"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback-model.area-project-navigator", defaultValue: "Project Navigator", comment: "Project navigator issue area"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback-model.area-extensions", defaultValue: "Extensions", comment: "Extensions issue area"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback-model.area-git", defaultValue: "Git", comment: "Git issue area"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback-model.area-debugger", defaultValue: "Debugger", comment: "Debugger issue area"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback-model.area-editor", defaultValue: "Editor", comment: "Editor issue area"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback-model.area-other", defaultValue: "Other", comment: "Other issue area"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback-model.label-project-navigator", defaultValue: "Project Navigator", comment: "Project navigator label")
        case "extensions":
            return String(localized: "feedback-model.label-extensions", defaultValue: "Extensions", comment: "Extensions label")
        case "git":
            return String(localized: "feedback-model.label-git", defaultValue: "Git", comment: "Git label")
        case "debugger":
            return String(localized: "feedback-model.label-debugger", defaultValue: "Debugger", comment: "Debugger label")
        case "editor":
            return String(localized: "feedback-model.label-editor", defaultValue: "Editor", comment: "Editor label")
        case "other":
            return String(localized: "feedback-model.label-other", defaultValue: "Other", comment: "Other label")
        default:
            return String(localized: "feedback-model.label-other-default", defaultValue: "Other", comment: "Other default label")
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
            return String(localized: "feedback-model.title-other", defaultValue: "Other", comment: "Other feedback type title")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback-model.type-bug-behaviour", defaultValue: "Bug", comment: "Bug label for behaviour")
        case "crash":
            return String(localized: "feedback-model.type-bug-crash", defaultValue: "Bug", comment: "Bug label for crash")
        case "unresponsive":
            return String(localized: "feedback-model.type-bug-unresponsive", defaultValue: "Bug", comment: "Bug label for unresponsive")
        case "suggestions":
            return String(localized: "feedback-model.type-suggestion-label", defaultValue: "Suggestion", comment: "Suggestion label")
        case "other":
            return String(localized: "feedback-model.type-feedback-label", defaultValue: "Feedback", comment: "Feedback label")
        default:
            return String(localized: "feedback-model.type-other-label", defaultValue: "Other", comment: "Other feedback type label")
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
