//
//  FeedbackView.swift
//  CodeEditModules/Feedback
//
//  Created by Nanashi Li on 2022/04/14.
//

import SwiftUI

struct FeedbackView: View {
    @ObservedObject private var feedbackModel: FeedbackModel = .shared

    @State var showsAlert: Bool = false

    @State var isSubmitButtonPressed: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    basicInformation
                    description
                }
                .padding(.horizontal, 90)
                .padding(.vertical, 30)
            }
            FeedbackToolbar {
                HelpButton(action: {})
                Spacer()
                if feedbackModel.isSubmitted {
                    Text(String(localized: "feedback.view.submission.success", defaultValue: "Feedback submitted", comment: "Banner title shown when feedback submission succeeds"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.view.submission.failure", defaultValue: "Failed to submit feedback", comment: "Banner title shown when feedback submission fails"))
                }
                Button {
                    feedbackModel.createIssue(
                        title: feedbackModel.feedbackTitle,
                        description: feedbackModel.issueDescription,
                        steps: feedbackModel.stepsReproduceDescription,
                        expectation: feedbackModel.expectationDescription,
                        actuallyHappened: feedbackModel.whatHappenedDescription
                    )
                    isSubmitButtonPressed = true
                } label: {
                    Text(String(localized: "feedback.view.submit", defaultValue: "Submit", comment: "Primary button title for submitting feedback"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.view.no-github-account.title", defaultValue: "No GitHub Account", comment: "Alert title shown when no GitHub account is configured")),
                        message: Text(String(localized: "feedback.view.no-github-account.message", defaultValue: "A GitHub account is required to submit feedback.", comment: "Alert message explaining GitHub account requirement")),
                        primaryButton: .default(Text(String(localized: "feedback.view.no-github-account.cancel", defaultValue: "Cancel", comment: "Cancel button title in no account alert"))),
                        secondaryButton: .default(Text(String(localized: "feedback.view.no-github-account.add-account", defaultValue: "Add Account", comment: "Action button title to add an account in no account alert")))
                    )
                }
            }
            .padding(10)
            .border(Color(NSColor.separatorColor))
        }
        .frame(width: 1028, height: 762)
    }

    private var basicInformation: some View {
        VStack(alignment: .leading) {
            Text(String(localized: "feedback.view.section.basic-information", defaultValue: "Basic Information", comment: "Section header for basic feedback information"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.title.prompt.primary", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt asking for descriptive feedback title (primary location)"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.title.prompt.secondary", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt asking for descriptive feedback title (secondary location)"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.view.title.example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Placeholder example for feedback title field"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueAreaListSelection == String(localized: "feedback.view.problem-area.none", defaultValue: "none", comment: "Fallback text shown when no problem area is selected") {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.problem-area.prompt.primary", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt asking user to choose affected area (primary location)"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.problem-area.prompt.secondary", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt asking user to choose affected area (secondary location)"))
                    }
                }
                Picker("", selection: $feedbackModel.issueAreaListSelection) {
                    ForEach(feedbackModel.issueAreaList) {
                        if feedbackModel.issueAreaListSelection == String(localized: "feedback.view.problem-area.none-secondary", defaultValue: "none", comment: "Fallback text shown when no problem area is selected (secondary location)") {
                            Text($0.name)
                                .tag($0.id)
                                .foregroundColor(.secondary)
                        } else {
                            Text($0.name).tag($0.id)
                        }
                    }
                }
                .frame(width: 350)
                .labelsHidden()
            }
            .padding(.top)

            VStack(alignment: .leading) {
                if isSubmitButtonPressed && feedbackModel.feedbackTypeListSelection == String(localized: "feedback.view.feedback-type.none", defaultValue: "none", comment: "Fallback text shown when no feedback type is selected") {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.red)
                        Text(String(localized: "feedback.view.feedback-type.prompt.primary", defaultValue: "What type of feedback are you reporting?", comment: "Prompt asking user to choose feedback type (primary location)"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.view.feedback-type.prompt.secondary", defaultValue: "What type of feedback are you reporting?", comment: "Prompt asking user to choose feedback type (secondary location)"))
                }
                Picker("", selection: $feedbackModel.feedbackTypeListSelection) {
                    ForEach(feedbackModel.feedbackTypeList) {
                        if feedbackModel.feedbackTypeListSelection == String(localized: "feedback.view.feedback-type.none-secondary", defaultValue: "none", comment: "Fallback text shown when no feedback type is selected (secondary location)") {
                            Text($0.name)
                                .tag($0.id)
                                .foregroundColor(.secondary)
                        } else {
                            Text($0.name).tag($0.id)
                        }
                    }
                }
                .frame(width: 350)
                .labelsHidden()
            }
            .padding(.top)
        }
    }

    private var description: some View {
        VStack(alignment: .leading) {
            Text(String(localized: "feedback.view.description", defaultValue: "Description", comment: "Section title for detailed feedback description"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.issue-description.prompt.primary", defaultValue: "Please describe the issue:", comment: "Prompt asking user to describe the issue (primary location)"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.issue-description.prompt.secondary", defaultValue: "Please describe the issue:", comment: "Prompt asking user to describe the issue (secondary location)"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.issue-description.example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Example text for issue description field"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.steps-to-reproduce.prompt", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Prompt asking user to list reproduction steps"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.steps-to-reproduce.example.label", defaultValue: "Example:", comment: "Label introducing example reproduction steps"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.steps-to-reproduce.example.step1", defaultValue: "1. Open the attached sample project", comment: "First example reproduction step"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.steps-to-reproduce.example.step2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Second example reproduction step"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.expectation.prompt", defaultValue: "What did you expect to happen?", comment: "Prompt asking what behavior was expected"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.expectation.example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Example text for expected behavior field"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.actual-result.prompt", defaultValue: "What actually happened?", comment: "Prompt asking what behavior actually occurred"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.view.actual-result.example", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Example text for actual behavior field"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)
        }
    }

    func showWindow() {
        FeedbackWindowController(view: self, size: NSSize(width: 1028, height: 762)).showWindow(nil)
    }
}
