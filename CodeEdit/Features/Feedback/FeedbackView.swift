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
                    Text(String(localized: "feedback.submitted", defaultValue: "Feedback submitted", comment: "Feedback submitted status"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.failed-to-submit", defaultValue: "Failed to submit feedback", comment: "Failed to submit feedback status"))
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
                    Text(String(localized: "feedback.submit", defaultValue: "Submit", comment: "Submit button"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.no-github-account", defaultValue: "No GitHub Account", comment: "No GitHub account alert title")),
                        message: Text(String(localized: "feedback.github-account-required", defaultValue: "A GitHub account is required to submit feedback.", comment: "GitHub account required message")),
                        primaryButton: .default(Text(String(localized: "common.cancel", defaultValue: "Cancel", comment: "Cancel button"))),
                        secondaryButton: .default(Text(String(localized: "feedback.add-account", defaultValue: "Add Account", comment: "Add account button")))
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
            Text(String(localized: "feedback.basic-information", defaultValue: "Basic Information", comment: "Basic information section title"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.provide-title", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Feedback title prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.provide-title", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Feedback title prompt"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.title-example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Feedback title example"))
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
                            Text(String(localized: "feedback.which-area", defaultValue: "Which area are you seeing an issue with?", comment: "Issue area prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.which-area", defaultValue: "Which area are you seeing an issue with?", comment: "Issue area prompt"))
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
                        Text(String(localized: "feedback.feedback-type", defaultValue: "What type of feedback are you reporting?", comment: "Feedback type prompt"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.feedback-type", defaultValue: "What type of feedback are you reporting?", comment: "Feedback type prompt"))
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
            Text(String(localized: "feedback.description", defaultValue: "Description", comment: "Description section title"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.describe-issue", defaultValue: "Please describe the issue:", comment: "Issue description prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.describe-issue", defaultValue: "Please describe the issue:", comment: "Issue description prompt"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.description-example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Issue description example"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.list-steps", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Reproduction steps prompt"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.example", defaultValue: "Example:", comment: "Example label"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.step-example-1", defaultValue: "1. Open the attached sample project", comment: "Reproduction step example 1"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.step-example-2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Reproduction step example 2"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.expected-behavior", defaultValue: "What did you expect to happen?", comment: "Expected behavior prompt"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.expected-example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Expected behavior example"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.actual-behavior", defaultValue: "What actually happened?", comment: "Actual behavior prompt"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.actual-example", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Actual behavior example"))
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
