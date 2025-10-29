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
        FeedbackType(name: String(localized: "Choose...", comment: "Default feedback type selection prompt"), id: "none"),
        FeedbackType(name: String(localized: "Incorrect/Unexpected Behaviour", comment: "Feedback type for incorrect behavior"), id: "behaviour"),
        FeedbackType(name: String(localized: "Application Crash", comment: "Feedback type for crashes"), id: "crash"),
        FeedbackType(name: String(localized: "Application Slow/Unresponsive", comment: "Feedback type for performance issues"), id: "unresponsive"),
        FeedbackType(name: String(localized: "Suggestion", comment: "Feedback type for suggestions"), id: "suggestions"),
        FeedbackType(name: String(localized: "Other", comment: "Feedback type for other issues"), id: "other")
    ]

    @Published var issueAreaList = [
        FeedbackIssueArea(name: String(localized: "Please select the problem area", comment: "Default issue area selection prompt"), id: "none"),
        FeedbackIssueArea(name: String(localized: "Project Navigator", comment: "Issue area for project navigator"), id: "projectNavigator"),
        FeedbackIssueArea(name: String(localized: "Extensions", comment: "Issue area for extensions"), id: "extensions"),
        FeedbackIssueArea(name: String(localized: "Git", comment: "Issue area for Git"), id: "git"),
        FeedbackIssueArea(name: String(localized: "Debugger", comment: "Issue area for debugger"), id: "debugger"),
        FeedbackIssueArea(name: "Editor", id: "editor"),
        FeedbackIssueArea(name: String(localized: "Other", comment: "Issue area for other issues"), id: "other")
    ]

    /// Gets the ID of the selected issue type and then
    /// cross references it to select the right Label based on the type
    private func getIssueLabel() -> String {
        switch issueAreaListSelection {
        case "projectNavigator":
            return String(localized: "Project Navigator", comment: "Issue label for project navigator")
        case "extensions":
            return String(localized: "Extensions", comment: "Issue label for extensions")
        case "git":
            return String(localized: "Git", comment: "Issue label for Git")
        case "debugger":
            return String(localized: "Debugger", comment: "Issue label for debugger")
        case "editor":
            return "Editor"
        case "other":
            return String(localized: "Other", comment: "Issue label for other")
        default:
            return String(localized: "Other", comment: "Issue label for other")
        }
    }

    /// This is just temporary till we have bot that will handle this
    private func getFeedbackTypeTitle() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "🐞", comment: "Bug emoji for behavior issues")
        case "crash":
            return String(localized: "🐞", comment: "Bug emoji for crashes")
        case "unresponsive":
            return String(localized: "🐞", comment: "Bug emoji for unresponsive issues")
        case "suggestions":
            return "✨"
        case "other":
            return "📬"
        default:
            return String(localized: "Other", comment: "Default feedback type title")
        }
    }

    /// Gets the ID of the selected feedback type and then
    /// cross references it to select the right Label based on the type
    private func getFeedbackTypeLabel() -> String {
        switch feedbackTypeListSelection {
        case "behaviour":
            return String(localized: "Bug", comment: "Feedback type label for behavior issues")
        case "crash":
            return String(localized: "Bug", comment: "Feedback type label for crash issues")
        case "unresponsive":
            return String(localized: "Bug", comment: "Feedback type label for unresponsive issues")
        case "suggestions":
            return String(localized: "Suggestion", comment: "Feedback type label for suggestions")
        case "other":
            return String(localized: "Feedback", comment: "Feedback type label for other issues")
        default:
            return String(localized: "Other", comment: "Default feedback type label")
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
        let descriptionLabel = String(localized: "**Description**", comment: "Issue body section header for description")
        let stepsLabel = String(localized: "**Steps to Reproduce**", comment: "Issue body section header for reproduction steps")
        let expectationLabel = String(localized: "**What did you expect to happen?**", comment: "Issue body section header for expected behavior")
        let actualLabel = String(localized: "**What actually happened?**", comment: "Issue body section header for actual behavior")
        let notApplicable = String(localized: "N/A", comment: "Not applicable placeholder")
        
        return """
        \(descriptionLabel)

        \(description)

        \(stepsLabel)

        \(steps ?? notApplicable)

        \(expectationLabel)

        \(expectation ?? notApplicable)

        \(actualLabel)

        \(actuallyHappened ?? notApplicable)
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
