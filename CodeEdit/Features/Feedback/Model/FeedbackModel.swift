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
        FeedbackType(name: String(localized: "feedback.choose", comment: "Feedback type placeholder"), id: "none"),
        FeedbackType(name: String(localized: "feedback.incorrectBehaviour", comment: "Feedback type option"), id: "behaviour"),
        FeedbackType(name: String(localized: "feedback.crash", comment: "Feedback type option"), id: "crash"),
        FeedbackType(name: String(localized: "feedback.slowUnresponsive", comment: "Feedback type option"), id: "unresponsive"),
        FeedbackType(name: String(localized: "feedback.suggestion", comment: "Feedback type option"), id: "suggestions"),
        FeedbackType(name: String(localized: "feedback.otherType", comment: "Feedback type option"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "feedback.selectProblemArea", comment: "Problem area placeholder"), id: "none"),
        FeedbackIssueArea(name: String(localized: "feedback.projectNavigator", comment: "Problem area option"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "feedback.extensions", comment: "Problem area option"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "feedback.git", comment: "Problem area option"), id: "git"),
        FeedbackIssueArea(name: String(localized: "feedback.debugger", comment: "Problem area option"), id: "debugger"),
        FeedbackIssueArea(name: String(localized: "feedback.editor", comment: "Problem area option"), id: "editor"),
        FeedbackIssueArea(name: String(localized: "feedback.otherArea", comment: "Problem area option"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "feedback.label.projectNavigator", comment: "GitHub issue label")
        case "extensions":
            return String(localized: "feedback.label.extensions", comment: "GitHub issue label")
        case "git":
            return String(localized: "feedback.label.git", comment: "GitHub issue label")
        case "debugger":
            return String(localized: "feedback.label.debugger", comment: "GitHub issue label")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "feedback.label.other", comment: "GitHub issue label")
        default:
            return String(localized: "feedback.label.otherDefault", comment: "GitHub issue label")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.emoji.bug", comment: "Bug emoji")
        case "crash":
            return String(localized: "feedback.emoji.bugCrash", comment: "Bug emoji")
        case "unresponsive":
            return String(localized: "feedback.emoji.bugUnresponsive", comment: "Bug emoji")
        case "suggestions":
            return String(localized: "feedback.emoji.suggestions", comment: "Suggestion emoji")
        case "other":
            return String(localized: "feedback.emoji.other", comment: "Other emoji")
        default:
            return String(localized: "feedback.default", comment: "Default feedback type")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "feedback.type.bug", comment: "Bug label")
        case "crash":
            return String(localized: "feedback.type.bugCrash", comment: "Bug label")
        case "unresponsive":
            return String(localized: "feedback.type.bugUnresponsive", comment: "Bug label")
        case "suggestions":
            return String(localized: "feedback.type.suggestion", comment: "Suggestion label")
        case "other":
            return String(localized: "feedback.type.feedback", comment: "Feedback label")
        default:
            return String(localized: "feedback.type.other", comment: "Other label")
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
        let descriptionLabel = String(localized: "feedback.body.description", comment: "Section label")
        let stepsLabel = String(localized: "feedback.body.stepsToReproduce", comment: "Section label")
        let expectationLabel = String(localized: "feedback.body.expectedBehavior", comment: "Section label")
        let actualLabel = String(localized: "feedback.body.actualBehavior", comment: "Section label")
        let naText = String(localized: "feedback.body.notApplicable", comment: "Not applicable text")
        
        return """
        **\(descriptionLabel)**

        \(description)

        **\(stepsLabel)**

        \(steps ?? naText)

        **\(expectationLabel)**

        \(expectation ?? naText)

        **\(actualLabel)**

        \(actuallyHappened ?? naText)
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
