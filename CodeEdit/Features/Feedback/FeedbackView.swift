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
                    Text(String(
                        localized: "feedback.alert.submitted.title",
                        defaultValue: "Feedback submitted",
                        comment: "Success alert title after submitting feedback"
                    ))
                } else if feedbackModel.failedToSubmit {
                    Text(String(
                        localized: "feedback.alert.submit-failed.title",
                        defaultValue: "Failed to submit feedback",
                        comment: "Failure alert title when feedback submission fails"
                    ))
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
                    Text(String(
                        localized: "feedback.action.submit",
                        defaultValue: "Submit",
                        comment: "Primary action button to submit feedback"
                    ))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(
                            localized: "feedback.github-account-required.title",
                            defaultValue: "No GitHub Account",
                            comment: "Alert title shown when no GitHub account is configured"
                        )),
                        message: Text(String(
                            localized: "feedback.github-account-required.message",
                            defaultValue: "A GitHub account is required to submit feedback.",
                            comment: "Alert message explaining GitHub account requirement for feedback"
                        )),
                        primaryButton: .default(Text(String(
                            localized: "feedback.github-account-required.action.cancel",
                            defaultValue: "Cancel",
                            comment: "Cancel action in GitHub account requirement alert"
                        ))),
                        secondaryButton: .default(Text(String(
                            localized: "feedback.github-account-required.action.add-account",
                            defaultValue: "Add Account",
                            comment: "Action to add a GitHub account from feedback alert"
                        )))
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
            Text(String(
                localized: "feedback.section.basic-information",
                defaultValue: "Basic Information",
                comment: "Section header for basic feedback form information"
            ))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(
                                localized: "feedback.title.prompt",
                                defaultValue: "Please provide a descriptive title for your feedback:",
                                comment: "Prompt asking user for descriptive feedback title"
                            ))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(
                            localized: "feedback.title.field-label",
                            defaultValue: "Please provide a descriptive title for your feedback:",
                            comment: "Field label for feedback title input"
                        ))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(
                    localized: "feedback.title.placeholder-example",
                    defaultValue: "Example: CodeEdit crashes when using autocomplete",
                    comment: "Placeholder example text for feedback title field"
                ))
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
                            Text(String(
                                localized: "feedback.area.prompt",
                                defaultValue: "Which area are you seeing an issue with?",
                                comment: "Prompt asking which product area has an issue"
                            ))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(
                            localized: "feedback.area.field-label",
                            defaultValue: "Which area are you seeing an issue with?",
                            comment: "Field label for selecting affected product area"
                        ))
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
                        Text(String(
                            localized: "feedback.type.prompt",
                            defaultValue: "What type of feedback are you reporting?",
                            comment: "Prompt asking for feedback type"
                        ))
                    }.padding(.leading, -23)
                } else {
                    Text(String(
                        localized: "feedback.type.field-label",
                        defaultValue: "What type of feedback are you reporting?",
                        comment: "Field label for feedback type selection"
                    ))
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
            Text(String(
                localized: "feedback.section.description",
                defaultValue: "Description",
                comment: "Section header for feedback description"
            ))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(
                                localized: "feedback.description.prompt",
                                defaultValue: "Please describe the issue:",
                                comment: "Prompt asking user to describe reported issue"
                            ))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(
                            localized: "feedback.description.field-label",
                            defaultValue: "Please describe the issue:",
                            comment: "Field label for issue description input"
                        ))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(
                    localized: "feedback.description.placeholder-example",
                    defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.",
                    comment: "Placeholder example text for issue description field"
                ))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(
                    localized: "feedback.repro-steps.prompt",
                    defaultValue: "Please list the steps you took to reproduce the issue:",
                    comment: "Prompt asking user for reproduction steps"
                ))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(
                    localized: "feedback.repro-steps.example-label",
                    defaultValue: "Example:",
                    comment: "Label introducing reproduction steps example"
                ))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(
                    localized: "feedback.repro-steps.example.step-1",
                    defaultValue: "1. Open the attached sample project",
                    comment: "First sample reproduction step"
                ))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(
                    localized: "feedback.repro-steps.example.step-2",
                    defaultValue: "2. type #import and wait for autocompletion to begin",
                    comment: "Second sample reproduction step"
                ))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(
                    localized: "feedback.expected-result.prompt",
                    defaultValue: "What did you expect to happen?",
                    comment: "Prompt asking for expected behavior"
                ))
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text(String(
                    localized: "feedback.expected-result.example",
                    defaultValue: "Example: I expected autocomplete to show me a list of headers.",
                    comment: "Example text for expected behavior"
                ))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(
                    localized: "feedback.actual-result.prompt",
                    defaultValue: "What actually happened?",
                    comment: "Prompt asking for actual observed behavior"
                ))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(
                    localized: "feedback.actual-result.example",
                    defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.",
                    comment: "Example text for actual observed behavior"
                ))
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
