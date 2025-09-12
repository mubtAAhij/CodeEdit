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
                    Text("String(localized: "feedback_submitted", comment: "Message shown when feedback is successfully submitted")")
                } else if feedbackModel.failedToSubmit {
                    Text("String(localized: "feedback_submit_failed", comment: "Error message when feedback submission fails")")
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
                    Text("String(localized: "submit_button", comment: "Submit button text")")
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text("String(localized: "no_github_account_title", comment: "Alert title when no GitHub account is configured")"),
                        message: Text("String(localized: "github_account_required_message", comment: "Alert message explaining GitHub account requirement")"),
                        primaryButton: .default(Text("String(localized: "cancel_button", comment: "Cancel button text")")),
                        secondaryButton: .default(Text("String(localized: "add_account_button", comment: "Button to add GitHub account")"))
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
            Text("String(localized: "basic_information_section", comment: "Section header for basic feedback information")")
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("String(localized: "feedback_title_prompt", comment: "Prompt for feedback title input")")
                        }.padding(.leading, -23)
                    } else {
                        Text("String(localized: "feedback_title_prompt", comment: "Prompt for feedback title input")")
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text("String(localized: "feedback_title_example", comment: "Example text for feedback title")")
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
                            Text("String(localized: "issue_area_prompt", comment: "Prompt for selecting issue area")")
                        }.padding(.leading, -23)
                    } else {
                        Text("String(localized: "issue_area_prompt", comment: "Prompt for selecting issue area")")
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
                        Text("String(localized: "feedback_type_prompt", comment: "Prompt for selecting feedback type")")
                    }.padding(.leading, -23)
                } else {
                    Text("String(localized: "feedback_type_prompt", comment: "Prompt for selecting feedback type")")
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
            Text("String(localized: "description_section", comment: "Section header for feedback description")")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("String(localized: "issue_description_prompt", comment: "Prompt for issue description")")
                        }.padding(.leading, -23)
                    } else {
                        Text("String(localized: "issue_description_prompt", comment: "Prompt for issue description")")
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("String(localized: "issue_description_example", comment: "Example text for issue description")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text("String(localized: "reproduction_steps_prompt", comment: "Prompt for reproduction steps")")
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("String(localized: "example_label", comment: "Label for example text")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("String(localized: "reproduction_step_1_example", comment: "First example step for reproduction")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("String(localized: "reproduction_step_2_example", comment: "Second example step for reproduction")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("String(localized: "feedback_expected_behavior", comment: "Label asking user what they expected to happen")")
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("String(localized: "feedback_expected_behavior_example", comment: "Example text for expected behavior description")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("String(localized: "feedback_actual_behavior", comment: "Label asking user what actually happened")")
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text("String(localized: "feedback_actual_behavior_example", comment: "Example text for actual behavior description")")
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
