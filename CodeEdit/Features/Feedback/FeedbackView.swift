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
                    Text(String(localized: "feedback.view.toast.submitted", defaultValue: "Feedback submitted", comment: "Success toast title shown after feedback submission"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.view.toast.submit-failed", defaultValue: "Failed to submit feedback", comment: "Error toast title shown when feedback submission fails"))
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
                    Text(String(localized: "feedback.view.actions.submit", defaultValue: "Submit", comment: "Primary button title to submit feedback"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.view.alert.no-github-account.title", defaultValue: "No GitHub Account", comment: "Alert title shown when no GitHub account is configured")),
                        message: Text(String(localized: "feedback.view.alert.no-github-account.message", defaultValue: "A GitHub account is required to submit feedback.", comment: "Alert message explaining that a GitHub account is required")),
                        primaryButton: .default(Text(String(localized: "feedback.view.alert.no-github-account.cancel", defaultValue: "Cancel", comment: "Cancel button title in no GitHub account alert"))),
                        secondaryButton: .default(Text(String(localized: "feedback.view.alert.no-github-account.add-account", defaultValue: "Add Account", comment: "Button title to add a GitHub account from alert")))
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
                            Text(String(localized: "feedback.view.validation.title-required.message", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Validation message requesting a descriptive feedback title"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.validation.title-required.message", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Validation message requesting a descriptive feedback title"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.view.title.placeholder.example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Placeholder example text for feedback title input"))
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
                            Text(String(localized: "feedback.view.area.prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt asking user which area has an issue"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.area.prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt asking user which area has an issue"))
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
                        Text(String(localized: "feedback.view.type.prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt asking user for feedback type"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.view.type.prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt asking user for feedback type"))
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
            Text(String(localized: "feedback.view.description.title", defaultValue: "Description", comment: "Section title for feedback description field"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.issue-description.prompt", defaultValue: "Please describe the issue:", comment: "Prompt asking the user to describe the reported issue"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.issue-description.prompt", defaultValue: "Please describe the issue:", comment: "Prompt asking the user to describe the reported issue"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.issue-description.example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Example text for issue description input"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text("Please list the steps you took to reproduce the issue:")
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.repro-steps.example-label", defaultValue: "Example:", comment: "Label introducing example reproduction steps"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.repro-steps.example.step1", defaultValue: "1. Open the attached sample project", comment: "First example step for reproducing an issue"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.repro-steps.example.step2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Second example step for reproducing an issue"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.expected-behavior.prompt", defaultValue: "What did you expect to happen?", comment: "Prompt asking user for expected behavior"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.expected-behavior.example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Example text for expected behavior input"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.actual-behavior.prompt", defaultValue: "What actually happened?", comment: "Prompt asking user for actual behavior"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text("Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.")
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
