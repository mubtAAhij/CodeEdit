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
                    Text(String(localized: "feedback.submitted", defaultValue: "Feedback submitted", comment: "Feedback submitted status message"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.submit-failed", defaultValue: "Failed to submit feedback", comment: "Failed to submit feedback error message"))
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
                    Text(String(localized: "feedback.submit", defaultValue: "Submit", comment: "Submit feedback button label"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.no-github-account.title", defaultValue: "No GitHub Account", comment: "No GitHub Account alert title")),
                        message: Text(String(localized: "feedback.no-github-account.message", defaultValue: "A GitHub account is required to submit feedback.", comment: "No GitHub Account alert message")),
                        primaryButton: .default(Text(String(localized: "feedback.cancel", defaultValue: "Cancel", comment: "Cancel button label"))),
                        secondaryButton: .default(Text(String(localized: "feedback.add-account", defaultValue: "Add Account", comment: "Add Account button label")))
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
            Text(String(localized: "feedback.basic-information", defaultValue: "Basic Information", comment: "Basic Information section title"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.title.prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Feedback title prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.title.prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Feedback title prompt"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.title.example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Feedback title example"))
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
                            Text(String(localized: "feedback.issue-area.prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Issue area prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.issue-area.prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Issue area prompt"))
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
                        Text(String(localized: "feedback.feedback-type.prompt", defaultValue: "What type of feedback are you reporting?", comment: "Feedback type prompt"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.feedback-type.prompt", defaultValue: "What type of feedback are you reporting?", comment: "Feedback type prompt"))
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
                            Text(String(localized: "feedback.describe-issue.prompt", defaultValue: "Please describe the issue:", comment: "Describe issue prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.describe-issue.prompt", defaultValue: "Please describe the issue:", comment: "Describe issue prompt"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.describe-issue.example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Describe issue example"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.steps-to-reproduce.prompt", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Steps to reproduce prompt"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.steps-to-reproduce.example-header", defaultValue: "Example:", comment: "Steps to reproduce example header"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.steps-to-reproduce.example-step1", defaultValue: "1. Open the attached sample project", comment: "Steps to reproduce example step 1"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.steps-to-reproduce.example-step2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Steps to reproduce example step 2"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.expected-behavior.prompt", defaultValue: "What did you expect to happen?", comment: "Expected behavior prompt"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.expected-behavior.example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Expected behavior example"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.actual-behavior.prompt", defaultValue: "What actually happened?", comment: "Actual behavior prompt"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.actual-behavior.example", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Actual behavior example"))
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
