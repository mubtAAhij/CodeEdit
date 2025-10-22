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
                    Text("feedback.submitted", comment: "Status message")
                } else if feedbackModel.failedToSubmit {
                    Text("feedback.failed", comment: "Error message")
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
                    Text("feedback.submit", comment: "Button text")
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text("feedback.no_github_account", comment: "Alert title"),
                        message: Text("feedback.github_account_required", comment: "Alert message"),
                        primaryButton: .default(Text("feedback.cancel", comment: "Button text")),
                        secondaryButton: .default(Text("feedback.add_account", comment: "Button text"))
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
            Text("feedback.basic_information", comment: "Section title")
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("feedback.provide_descriptive_title", comment: "Field label")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.provide_descriptive_title", comment: "Field label")
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text("feedback.title_example", comment: "Example text")
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
                            Text("feedback.which_area", comment: "Field label")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.which_area", comment: "Field label")
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
                        Text("feedback.what_type", comment: "Field label")
                    }.padding(.leading, -23)
                } else {
                    Text("feedback.what_type", comment: "Field label")
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
            Text("feedback.description", comment: "Section title")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("feedback.describe_issue", comment: "Field label")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.describe_issue", comment: "Field label")
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.description_example", comment: "Example text")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text("feedback.steps_to_reproduce", comment: "Field label")
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.example", comment: "Example label")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("feedback.example.step1", comment: "Example step")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("feedback.example.step2", comment: "Example step")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("feedback.expected_result", comment: "Field label")
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.expected_result.example", comment: "Example text")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("feedback.actual_result", comment: "Field label")
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text("feedback.actual_result.example", comment: "Example text")
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
