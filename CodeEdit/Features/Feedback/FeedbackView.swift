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
                    Text(String(localized: "feedback-submitted", defaultValue: "Feedback submitted", comment: "Feedback submitted status", os_id: "102000"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "failed-to-submit-feedback", defaultValue: "Failed to submit feedback", comment: "Failed to submit feedback status", os_id: "102001"))
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
                    Text(String(localized: "submit", defaultValue: "Submit", comment: "Submit button", os_id: "102002"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "no-github-account", defaultValue: "No GitHub Account", comment: "No GitHub account alert title", os_id: "102003")),
                        message: Text(String(localized: "github-account-required", defaultValue: "A GitHub account is required to submit feedback.", comment: "GitHub account required message", os_id: "102004")),
                        primaryButton: .default(Text(String(localized: "cancel", defaultValue: "Cancel", comment: "Cancel button"))),
                        secondaryButton: .default(Text(String(localized: "add-account", defaultValue: "Add Account", comment: "Add account button", os_id: "102005")))
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
            Text(String(localized: "basic-information", defaultValue: "Basic Information", comment: "Basic information section title", os_id: "102006"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "provide-descriptive-title", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Provide descriptive title prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "provide-descriptive-title", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Provide descriptive title label", os_id: "102007"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "example-title", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Example title text", os_id: "102008"))
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
                            Text(String(localized: "which-area-issue", defaultValue: "Which area are you seeing an issue with?", comment: "Which area issue prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "which-area-issue", defaultValue: "Which area are you seeing an issue with?", comment: "Which area issue label", os_id: "102009"))
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
                        Text(String(localized: "what-type-feedback", defaultValue: "What type of feedback are you reporting?", comment: "What type feedback prompt"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "what-type-feedback", defaultValue: "What type of feedback are you reporting?", comment: "What type feedback label", os_id: "102010"))
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
            Text(String(localized: "description", defaultValue: "Description", comment: "Description section title"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "describe-issue", defaultValue: "Please describe the issue:", comment: "Describe issue prompt"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "describe-issue", defaultValue: "Please describe the issue:", comment: "Describe issue label", os_id: "102012"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "example-description", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Example description text", os_id: "102013"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "list-steps-reproduce", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "List steps to reproduce label", os_id: "102014"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "example", defaultValue: "Example:", comment: "Example label", os_id: "102015"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "example-step-1", defaultValue: "1. Open the attached sample project", comment: "Example step 1", os_id: "102016"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "example-step-2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Example step 2", os_id: "102017"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "what-did-you-expect", defaultValue: "What did you expect to happen?", comment: "What did you expect label", os_id: "102018"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "example-expectation", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Example expectation text", os_id: "102019"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "what-actually-happened", defaultValue: "What actually happened?", comment: "What actually happened label", os_id: "102020"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "example-actual", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Example actual text", os_id: "102021"))
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
