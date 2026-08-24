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
                    Text(String(localized: "feedback.view.toast.submitted", defaultValue: "Feedback submitted", comment: "Success message shown when feedback submission completes."))
                } else if feedbackModel.failedToSubmit {
                    Text(String(localized: "feedback.view.toast.submit-failed", defaultValue: "Failed to submit feedback", comment: "Error message shown when feedback submission fails."))
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
                    Text(String(localized: "feedback.view.actions.submit", defaultValue: "Submit", comment: "Primary action button title to submit feedback."))
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text(String(localized: "feedback.view.github-account-required.title", defaultValue: "No GitHub Account", comment: "Alert title shown when no GitHub account is configured for feedback.")),
                        message: Text(String(localized: "feedback.view.github-account-required.message", defaultValue: "A GitHub account is required to submit feedback.", comment: "Alert message explaining GitHub account requirement for feedback submission.")),
                        primaryButton: .default(Text(String(localized: "feedback.view.github-account-required.cancel", defaultValue: "Cancel", comment: "Cancel action in missing GitHub account alert."))),
                        secondaryButton: .default(Text(String(localized: "feedback.view.github-account-required.add-account", defaultValue: "Add Account", comment: "Action to open account setup from missing GitHub account alert.")))
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
            Text(String(localized: "feedback.view.section.basic-information", defaultValue: "Basic Information", comment: "Section heading for basic feedback information."))
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.title.prompt.primary", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Prompt asking user to enter a descriptive feedback title."))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.title.prompt.secondary", defaultValue: "Please provide a descriptive title for your feedback:", comment: "Secondary prompt asking user to enter a descriptive feedback title."))
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text(String(localized: "feedback.view.title.example", defaultValue: "Example: CodeEdit crashes when using autocomplete", comment: "Example placeholder text for feedback title field."))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueAreaListSelection == String(localized: "feedback.view.selection.none.area", defaultValue: "none", comment: "Fallback text for no selected problem area.") {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.problem-area.prompt.primary", defaultValue: "Which area are you seeing an issue with?", comment: "Primary prompt asking user to select affected problem area."))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.problem-area.prompt.secondary", defaultValue: "Which area are you seeing an issue with?", comment: "Secondary prompt asking user to select affected problem area."))
                    }
                }
                Picker("", selection: $feedbackModel.issueAreaListSelection) {
                    ForEach(feedbackModel.issueAreaList) {
                        if feedbackModel.issueAreaListSelection == String(localized: "feedback.view.selection.none.area-inline", defaultValue: "none", comment: "Inline fallback text for no selected problem area.") {
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
                if isSubmitButtonPressed && feedbackModel.feedbackTypeListSelection == String(localized: "feedback.view.selection.none.problem-area-summary", defaultValue: "none", comment: "Summary fallback text for no selected problem area.") {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.red)
                        Text(String(localized: "feedback.view.feedback-type.prompt.primary", defaultValue: "What type of feedback are you reporting?", comment: "Primary prompt asking user to select feedback type."))
                    }.padding(.leading, -23)
                } else {
                    Text(String(localized: "feedback.view.feedback-type.prompt.secondary", defaultValue: "What type of feedback are you reporting?", comment: "Secondary prompt asking user to select feedback type."))
                }
                Picker("", selection: $feedbackModel.feedbackTypeListSelection) {
                    ForEach(feedbackModel.feedbackTypeList) {
                        if feedbackModel.feedbackTypeListSelection == String(localized: "feedback.view.selection.none.type", defaultValue: "none", comment: "Fallback text for no selected feedback type.") {
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
            Text(String(localized: "feedback.view.description.section-title", defaultValue: "Description", comment: "Section title for feedback description input."))
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(String(localized: "feedback.view.description.prompt.primary", defaultValue: "Please describe the issue:", comment: "Primary prompt asking user to describe the issue."))
                        }.padding(.leading, -23)
                    } else {
                        Text(String(localized: "feedback.view.description.prompt.secondary", defaultValue: "Please describe the issue:", comment: "Secondary prompt asking user to describe the issue."))
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                    .frame(minHeight: 127, alignment: .leading)
                    .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.description.example.crash-autocomplete-popup", defaultValue: "Example: CodeEdit crashes when the autocomplete popup appears on screen.", comment: "Example text for issue description field."))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.repro-steps.prompt", defaultValue: "Please list the steps you took to reproduce the issue:", comment: "Prompt asking user for issue reproduction steps."))
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                    .frame(minHeight: 60, alignment: .leading)
                    .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.repro-steps.example.label", defaultValue: "Example:", comment: "Label introducing reproduction steps example."))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.repro-steps.example.step-1", defaultValue: "1. Open the attached sample project", comment: "First example reproduction step."))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text(String(localized: "feedback.view.repro-steps.example.step-2", defaultValue: "2. type #import and wait for autocompletion to begin", comment: "Second example reproduction step."))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.expected-result.prompt", defaultValue: "What did you expect to happen?", comment: "Prompt asking expected behavior."))
                TextEditor(text: $feedbackModel.expectationDescription)
                    .frame(minHeight: 60, alignment: .leading)
                    .border(Color(NSColor.separatorColor))
                Text(String(localized: "feedback.view.expected-result.example", defaultValue: "Example: I expected autocomplete to show me a list of headers.", comment: "Example text for expected behavior field."))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text(String(localized: "feedback.view.actual-result.prompt", defaultValue: "What actually happened?", comment: "Prompt asking actual observed behavior."))
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                    .frame(minHeight: 60, alignment: .leading)
                    .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text(String(localized: "feedback.example.description", defaultValue: "Example: The autocomplete window flickered on screen and CodeEdit crashed. See attached crashlog.", comment: "Example text shown in feedback form to illustrate issue description"))
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
