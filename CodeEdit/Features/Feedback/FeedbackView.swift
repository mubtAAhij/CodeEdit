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
                    Text(String(localized: "feedback.status.submitted", comment: "Message shown when feedback is successfully submitted"))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.status.failed", comment: "Message shown when feedback submission fails"))
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
                    Text(String(localized: "feedback.submit", comment: "Button text for submitting feedback"))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.alert.no_github_account.title", comment: "Alert title when no GitHub account is configured")),
                        message: Text(String(localized: "feedback.alert.no_github_account.message", comment: "Alert message when no GitHub account is configured")),
                        primaryButton: .default(Text(String(localized: "feedback.alert.cancel", comment: "Cancel button text in alert"))),
                        secondaryButton: .default(Text(String(localized: "feedback.alert.add_account", comment: "Button text for adding GitHub account")))
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
            Text(String(localized: "feedback.section.basic_information", comment: "Section header for basic feedback information"))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.title.prompt", comment: "Prompt asking user to provide a descriptive title for feedback"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.title.prompt", comment: "Prompt asking user to provide a descriptive title for feedback"))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.title.example", comment: "Example text for feedback title"))
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
                            Text(String(localized: "feedback.area.prompt", comment: "Prompt asking user to select which area has an issue"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.area.prompt", comment: "Prompt asking user to select which area has an issue"))
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
                        Text(String(localized: "feedback.type.prompt", comment: "Prompt asking user to select feedback type"))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.type.prompt", comment: "Prompt asking user to select feedback type"))
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
            Text(String(localized: "feedback.section.description", comment: "Section header for feedback description"))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.description.prompt", comment: "Prompt asking user to describe the issue"))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.description.prompt", comment: "Prompt asking user to describe the issue"))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.description.example", comment: "Example text for issue description"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.reproduction.prompt", comment: "Prompt asking user to list reproduction steps"))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.example_label", comment: "Label for example text in feedback form"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.example_step_1", comment: "First example step in feedback reproduction steps"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.example_step_2", comment: "Second example step in feedback reproduction steps"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.expectation_question", comment: "Question asking what user expected to happen"))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.expectation_example", comment: "Example of what user expected to happen"))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.actual_result_question", comment: "Question asking what actually happened"))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.actual_result_example", comment: "Example of what actually happened"))
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
