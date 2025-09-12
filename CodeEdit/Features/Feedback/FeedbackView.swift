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
                    Text(String(localized: "feedback_submitted", comment: "Success message after feedback submission"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "failed_to_submit_feedback", comment: "Error message when feedback submission fails"))
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
                    Text(String(localized: "submit", comment: "Button label to submit feedback"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "no_github_account", comment: "Alert title when no GitHub account is found")),
                        message: Text(String(localized: "github_account_required", comment: "Alert message explaining GitHub account is needed")),
                        primaryButton: .default(Text(String(localized: "cancel", comment: "Button label to cancel action"))),
                        secondaryButton: .default(Text(String(localized: "add_account", comment: "Button label to add GitHub account")))
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
            Text(String(localized: "basic_information", comment: "Section header for basic feedback information"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("String(localized: "feedback_title_prompt", comment: "Prompt asking user to provide a descriptive title for their feedback")")
                        }.padding(.leading, -23)
                    } else {
                        Text("String(localized: "feedback_title_prompt", comment: "Prompt asking user to provide a descriptive title for their feedback")")
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text("String(localized: "feedback_title_example", comment: "Example text showing what a good feedback title looks like")")
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
                            Text("String(localized: "feedback_issue_area_prompt", comment: "Prompt asking user to select which area they are having issues with")")
                        }.padding(.leading, -23)
                    } else {
                        Text("String(localized: "feedback_issue_area_prompt", comment: "Prompt asking user to select which area they are having issues with")")
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
                        Text("String(localized: "feedback_type_prompt", comment: "Prompt asking user to select what type of feedback they are reporting")")
                    }.padding(.leading, -23)
                } else {
                    Text("String(localized: "feedback_type_prompt", comment: "Prompt asking user to select what type of feedback they are reporting")")
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
            Text("String(localized: "feedback_description_title", comment: "Section title for the description area of the feedback form")")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("String(localized: "feedback_describe_issue_prompt", comment: "Prompt asking user to describe the issue they are experiencing")")
                        }.padding(.leading, -23)
                    } else {
                        Text("String(localized: "feedback_describe_issue_prompt", comment: "Prompt asking user to describe the issue they are experiencing")")
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("String(localized: "feedback_description_example", comment: "Example text showing how to describe an issue")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text("String(localized: "feedback_reproduction_steps_prompt", comment: "Prompt asking user to list steps to reproduce the issue")")
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("String(localized: "feedback_example_label", comment: "Label indicating example text follows")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("String(localized: "feedback_reproduction_step_1_example", comment: "Example first step in reproduction instructions")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("String(localized: "feedback_reproduction_step_2_example", comment: "Example second step in reproduction instructions")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("String(localized: "feedback_expectation_prompt", comment: "Prompt asking user what they expected to happen")")
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("String(localized: "feedback_expectation_example", comment: "Example text showing what user expected to happen")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("String(localized: "feedback_actual_result_prompt", comment: "Prompt asking user what actually happened instead")")
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text("String(localized: "feedback_actual_result_example", comment: "Example text showing what actually happened instead of expected behavior")")
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
