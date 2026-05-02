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
                    Text(String(localized: "feedback.submitted", defaultValue: "Feedback submitted", comment: "Status message when feedback is submitted"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.failed-to-submit", defaultValue: "Failed to submit feedback", comment: "Status message when feedback submission fails"))
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
                    Text(String(localized: "feedback.submit-button", defaultValue: "Submit", comment: "Button to submit feedback"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.no-github-account-title", defaultValue: "No GitHub Account", comment: "Alert title when GitHub account is missing")),
                        message: Text(String(localized: "feedback.no-github-account-message", defaultValue: "A GitHub account is required to submit feedback.", comment: "Alert message when GitHub account is missing")),
                        primaryButton: .default(Text(String(localized: "feedback.cancel", defaultValue: "Cancel", comment: "Button to cancel adding GitHub account"))),
                        secondaryButton: .default(Text(String(localized: "feedback.add-account-button", defaultValue: "Add Account", comment: "Button to add GitHub account")))
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
            Text(String(localized: "feedback.basic-information-title", defaultValue: "Basic Information", comment: "Section title for basic feedback information"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: String(localized: "feedback.required-field-icon", defaultValue: "arrow.right.circle.fill", comment: "SF Symbol for required field indicator"))
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.title-prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt for feedback title"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.title-prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt for feedback title"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.title-example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Example feedback title"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueAreaListSelection == String(localized: "feedback.picker.none-value", defaultValue: "none", comment: "Value for no selection in picker") {
                        HStack {
                            Image(systemName: String(localized: "feedback.required-field-icon", defaultValue: "arrow.right.circle.fill", comment: "SF Symbol for required field indicator"))
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.area-prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt for issue area selection"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.area-prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt for issue area selection"))
                    }
                }
                Picker("", selection: $feedbackModel.issueAreaListSelection) {
                    ForEach(feedbackModel.issueAreaList) {
                        if feedbackModel.issueAreaListSelection == String(localized: "feedback.picker.none-value", defaultValue: "none", comment: "Value for no selection in picker") {
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
                if isSubmitButtonPressed && feedbackModel.feedbackTypeListSelection == String(localized: "feedback.picker.none-value", defaultValue: "none", comment: "Value for no selection in picker") {
                    HStack {
                        Image(systemName: String(localized: "feedback.required-field-icon", defaultValue: "arrow.right.circle.fill", comment: "SF Symbol for required field indicator"))
                            .foregroundColor(.red)
                        Text(String(localized: "feedback.type-prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt for feedback type selection"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.type-prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt for feedback type selection"))
                }
                Picker("", selection: $feedbackModel.feedbackTypeListSelection) {
                    ForEach(feedbackModel.feedbackTypeList) {
                        if feedbackModel.feedbackTypeListSelection == String(localized: "feedback.picker.none-value", defaultValue: "none", comment: "Value for no selection in picker") {
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
            Text(String(localized: "feedback.description-title", defaultValue: "Description", comment: "Section title for feedback description"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: String(localized: "feedback.required-field-icon", defaultValue: "arrow.right.circle.fill", comment: "SF Symbol for required field indicator"))
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.issue-description-prompt", defaultValue: "Please describe the issue:", comment: "Prompt for issue description"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.issue-description-prompt", defaultValue: "Please describe the issue:", comment: "Prompt for issue description"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.issue-description-example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Example issue description"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.steps-to-reproduce-prompt", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Prompt for steps to reproduce"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.steps-example-label", defaultValue: "Example:", comment: "Label for example steps"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.steps-example-step1", defaultValue: "1. Open the attached sample project", comment: "Example step 1 for reproducing issue"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.steps-example-step2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Example step 2 for reproducing issue"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.expectation-prompt", defaultValue: "What did you expect to happen?", comment: "Prompt for expected behavior"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.expectation-example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Example expected behavior"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.actual-behavior-prompt", defaultValue: "What actually happened?", comment: "Prompt for actual behavior"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.actual-behavior-example", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Example actual behavior"))
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
