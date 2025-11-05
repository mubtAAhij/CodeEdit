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
                    Text(String(localized: "feedback.view.submitted", defaultValue: "Feedback submitted", comment: "Message when feedback is successfully submitted"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.view.failed", defaultValue: "Failed to submit feedback", comment: "Message when feedback submission fails"))
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
                    Text(String(localized: "feedback.view.submit-button", defaultValue: "Submit", comment: "Button to submit feedback"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.view.no-account-title", defaultValue: "No GitHub Account", comment: "Alert title when no GitHub account is configured")),
                        message: Text(String(localized: "feedback.view.no-account-message", defaultValue: "A GitHub account is required to submit feedback.", comment: "Alert message explaining GitHub account is required")),
                        primaryButton: .default(Text(String(localized: "button.cancel", defaultValue: "Cancel", comment: "Cancel button"))),
                        secondaryButton: .default(Text(String(localized: "feedback.view.add-account-button", defaultValue: "Add Account", comment: "Button to add GitHub account")))
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
            Text(String(localized: "feedback.view.basic-info-section", defaultValue: "Basic Information", comment: "Section title for basic information"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.title-prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt for feedback title"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.title-prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt for feedback title"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.view.title-example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Example text for feedback title"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueAreaListSelection == "none" {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.area-prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt for issue area selection"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.area-prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt for issue area selection"))
                    }
                }
                Picker("", selection: $feedbackModel.issueAreaListSelection) {
                    ForEach(feedbackModel.issueAreaList) {
                        if feedbackModel.issueAreaListSelection == "none" {
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
                if isSubmitButtonPressed && feedbackModel.feedbackTypeListSelection == "none" {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.red)
                        Text(String(localized: "feedback.view.type-prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt for feedback type selection"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.view.type-prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt for feedback type selection"))
                }
                Picker("", selection: $feedbackModel.feedbackTypeListSelection) {
                    ForEach(feedbackModel.feedbackTypeList) {
                        if feedbackModel.feedbackTypeListSelection == "none" {
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
            Text(String(localized: "feedback.view.description-section", defaultValue: "Description", comment: "Section title for description"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.issue-description-prompt", defaultValue: "Please describe the issue:", comment: "Prompt for issue description"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.issue-description-prompt", defaultValue: "Please describe the issue:", comment: "Prompt for issue description"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.issue-description-example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Example text for issue description"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.steps-prompt", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Prompt for reproduction steps"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.example-label", defaultValue: "Example:", comment: "Label for example text"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.steps-example-1", defaultValue: "1. Open the attached sample project", comment: "First step in reproduction example"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.steps-example-2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Second step in reproduction example"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.expectation-prompt", defaultValue: "What did you expect to happen?", comment: "Prompt for expected behavior"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.expectation-example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Example text for expected behavior"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.actual-behavior-prompt", defaultValue: "What actually happened?", comment: "Prompt for actual behavior"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.view.actual-behavior-example", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Example text for actual behavior"))
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
