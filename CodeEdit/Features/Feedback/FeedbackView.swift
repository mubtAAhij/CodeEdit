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
                    Text(String(localized: "feedback.submitted", defaultValue: "Feedback submitted", comment: "Message shown when feedback is submitted successfully"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.submit_failed", defaultValue: "Failed to submit feedback", comment: "Message shown when feedback submission fails"))
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
                    Text(String(localized: "feedback.submit", defaultValue: "Submit", comment: "Button to submit feedback"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.no_github_account", defaultValue: "No GitHub Account", comment: "Alert title when user has no GitHub account")),
                        message: Text(String(localized: "feedback.github_account_required", defaultValue: "A GitHub account is required to submit feedback.", comment: "Alert message explaining GitHub account is required")),
                        primaryButton: .default(Text(String(localized: "feedback.cancel", defaultValue: "Cancel", comment: "Button to cancel adding GitHub account"))),
                        secondaryButton: .default(Text(String(localized: "feedback.add_account", defaultValue: "Add Account", comment: "Button to add GitHub account")))
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
            Text(String(localized: "feedback.basic_information", defaultValue: "Basic Information", comment: "Section header for basic feedback information"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.title_prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt asking for feedback title"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.title_prompt", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt asking for feedback title"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.title_example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Example feedback title"))
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
                            Text(String(localized: "feedback.area_prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt asking which area has the issue"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.area_prompt", defaultValue: "Which area are you seeing an issue with?", comment: "Prompt asking which area has the issue"))
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
                        Text(String(localized: "feedback.type_prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt asking what type of feedback"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.type_prompt", defaultValue: "What type of feedback are you reporting?", comment: "Prompt asking what type of feedback"))
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
            Text(String(localized: "feedback.description", defaultValue: "Description", comment: "Section header for feedback description"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.issue_prompt", defaultValue: "Please describe the issue:", comment: "Prompt to describe the issue"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.issue_prompt", defaultValue: "Please describe the issue:", comment: "Prompt to describe the issue"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.issue_example", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Example issue description"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.steps_prompt", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Prompt for reproduction steps"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.steps_example_header", defaultValue: "Example:", comment: "Example header for reproduction steps"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.steps_example_step1", defaultValue: "1. Open the attached sample project", comment: "Example reproduction step 1"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.steps_example_step2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Example reproduction step 2"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.expectation_prompt", defaultValue: "What did you expect to happen?", comment: "Prompt for expected behavior"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.expectation_example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Example expected behavior"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.actual_prompt", defaultValue: "What actually happened?", comment: "Prompt for actual behavior"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.actual_example", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Example actual behavior"))
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
