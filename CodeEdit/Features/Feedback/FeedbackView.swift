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
                    Text(String(localized: "feedback.view.toast.submitted", defaultValue: "Feedback submitted", comment: "Success message shown after feedback submission"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.view.toast.submit-failed", defaultValue: "Failed to submit feedback", comment: "Error message shown when feedback submission fails"))
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
                    Text(String(localized: "feedback.view.button.submit", defaultValue: "Submit", comment: "Primary button title to submit feedback form"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.view.alert.no-account.title", defaultValue: "No GitHub Account", comment: "Alert title when no GitHub account is configured")),
                        message: Text(String(localized: "feedback.view.alert.no-account.message", defaultValue: "A GitHub account is required to submit feedback.", comment: "Alert message explaining GitHub account requirement for feedback submission")),
                        primaryButton: .default(Text(String(localized: "feedback.view.alert.no-account.cancel", defaultValue: "Cancel", comment: "Cancel button title in no-account alert"))),
                        secondaryButton: .default(Text(String(localized: "feedback.view.alert.no-account.add-account", defaultValue: "Add Account", comment: "Action button title to add a GitHub account from alert")))
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
            Text(String(localized: "feedback.view.section.basic-information", defaultValue: "Basic Information", comment: "Section header for basic feedback information fields"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.validation.title-required", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Validation message prompting for a descriptive feedback title"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.field.title.label", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Label text for feedback title input field"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.view.field.title.placeholder.example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Placeholder example for feedback title input"))
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
                            Text(String(localized: "feedback.view.validation.area-required", defaultValue: "Which area are you seeing an issue with?", comment: "Validation message prompting for feedback area selection"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.field.area.label", defaultValue: "Which area are you seeing an issue with?", comment: "Label text for feedback area picker"))
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
                        Text(String(localized: "feedback.view.validation.type-required", defaultValue: "What type of feedback are you reporting?", comment: "Validation message prompting for feedback type selection"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.view.field.type.label", defaultValue: "What type of feedback are you reporting?", comment: "Label text for feedback type picker"))
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
            Text(String(localized: "feedback.view.section.description", defaultValue: "Description", comment: "Section header for detailed feedback description"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.validation.description-required", defaultValue: "Please describe the issue:", comment: "Validation message prompting user to describe the issue"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.field.description.label", defaultValue: "Please describe the issue:", comment: "Label text for issue description input field"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.field.description.placeholder.example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Placeholder example for issue description input"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.field.steps.label", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Label text for reproduction steps input field"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.field.steps.example-prefix", defaultValue: "Example:", comment: "Prefix text introducing reproduction steps example"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.field.steps.example.step1", defaultValue: "1. Open the attached sample project", comment: "First sample step for reproducing issue"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.field.steps.example.step2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Second sample step for reproducing issue"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.field.expected.label", defaultValue: "What did you expect to happen?", comment: "Label text for expected behavior input field"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.field.expected.placeholder.example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Placeholder example for expected behavior input"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.field.actual.label", defaultValue: "What actually happened?", comment: "Label text for actual behavior input field"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.view.field.actual.placeholder.example", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Placeholder example for actual behavior input"))
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
