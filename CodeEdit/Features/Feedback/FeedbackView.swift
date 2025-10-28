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
                    Text("feedback.submitted", comment: "Feedback submitted message")
                } else if feedbackModel.failedToSubmit {
                    Text("feedback.submit_failed", comment: "Feedback submit failed message")
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
                    Text("feedback.submit", comment: "Submit button")
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text("feedback.no_github_account", comment: "No GitHub account alert title"),
                        message: Text("feedback.github_required", comment: "GitHub account required message"),
                        primaryButton: .default(Text("actions.cancel", comment: "Cancel button")),
                        secondaryButton: .default(Text("feedback.add_account", comment: "Add account button"))
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
            Text("feedback.basic_information", comment: "Basic Information section title")
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("feedback.provide_title", comment: "Provide descriptive title prompt")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.provide_title", comment: "Provide descriptive title prompt")
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text("feedback.title_example", comment: "Example feedback title")
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
                            Text("feedback.which_area", comment: "Which area prompt")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.which_area", comment: "Which area prompt")
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
                        Text("feedback.what_type", comment: "What type of feedback prompt")
                    }.padding(.leading, -23)
                } else {
                    Text("feedback.what_type", comment: "What type of feedback prompt")
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
            Text("feedback.description", comment: "Description section title")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("feedback.describe_issue", comment: "Please describe the issue prompt")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.describe_issue", comment: "Please describe the issue prompt")
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.description_example", comment: "Example issue description")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text("feedback.steps_to_reproduce", comment: "Steps to reproduce prompt")
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.steps_example", comment: "Example label for steps to reproduce")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("feedback.steps_example_1", comment: "Example step 1")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("feedback.steps_example_2", comment: "Example step 2")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("feedback.what_did_you_expect", comment: "What did you expect to happen prompt")
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.expectation_example", comment: "Example expectation")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("feedback.what_actually_happened", comment: "What actually happened prompt")
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text("feedback.actually_happened_example", comment: "Example of what actually happened")
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
