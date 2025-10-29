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
                    Text("feedback.submitted", comment: "Status message when feedback is successfully submitted")
                } else if feedbackModel.failedToSubmit {
                    Text("feedback.failed", comment: "Error message when feedback submission fails")
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
                    Text("feedback.submit", comment: "Button to submit feedback")
                }
                .alert(isPresented: self.$showsAlert) {
                    Alert(
                        title: Text("feedback.alert.noAccount.title", comment: "Alert title when user has no GitHub account"),
                        message: Text("feedback.alert.noAccount.message", comment: "Alert message explaining GitHub account requirement"),
                        primaryButton: .default(Text("feedback.alert.cancel", comment: "Cancel button in alert")),
                        secondaryButton: .default(Text("feedback.alert.addAccount", comment: "Button to add GitHub account"))
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
            Text("feedback.basicInfo.title", comment: "Section header for basic information")
                .fontWeight(.bold)
                .font(.system(size: 20))

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.feedbackTitle.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("feedback.basicInfo.titlePrompt", comment: "Prompt asking for feedback title")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.basicInfo.titlePrompt", comment: "Prompt asking for feedback title")
                    }
                }
                TextField("", text: $feedbackModel.feedbackTitle)
                Text("feedback.basicInfo.titleExample", comment: "Example of a good feedback title")
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
                            Text("feedback.basicInfo.areaPrompt", comment: "Prompt asking which area has an issue")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.basicInfo.areaPrompt", comment: "Prompt asking which area has an issue")
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
                        Text("feedback.basicInfo.typePrompt", comment: "Prompt asking what type of feedback")
                    }.padding(.leading, -23)
                } else {
                    Text("feedback.basicInfo.typePrompt", comment: "Prompt asking what type of feedback")
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
            Text("feedback.description.title", comment: "Section header for description")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.top)

            VStack(alignment: .leading) {
                HStack {
                    if isSubmitButtonPressed && feedbackModel.issueDescription.isEmpty {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text("feedback.description.issuePrompt", comment: "Prompt asking to describe the issue")
                        }.padding(.leading, -23)
                    } else {
                        Text("feedback.description.issuePrompt", comment: "Prompt asking to describe the issue")
                    }
                }
                TextEditor(text: $feedbackModel.issueDescription)
                           .frame(minHeight: 127, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.description.issueExample", comment: "Example of a good issue description")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top, -5)

            VStack(alignment: .leading) {
                Text("feedback.description.stepsPrompt", comment: "Prompt asking for steps to reproduce issue")
                TextEditor(text: $feedbackModel.stepsReproduceDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.description.stepsExample", comment: "Example label for steps to reproduce")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("feedback.description.stepsExample.step1", comment: "Example step 1 for reproducing an issue")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("feedback.description.stepsExample.step2", comment: "Example step 2 for reproducing an issue")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("feedback.description.expectationPrompt", comment: "Prompt asking what user expected to happen")
                TextEditor(text: $feedbackModel.expectationDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                Text("feedback.description.expectationExample", comment: "Example of what user expected to happen")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.top)

            VStack(alignment: .leading) {
                Text("feedback.description.actualPrompt", comment: "Prompt asking what actually happened")
                TextEditor(text: $feedbackModel.whatHappenedDescription)
                           .frame(minHeight: 60, alignment: .leading)
                           .border(Color(NSColor.separatorColor))
                // swiftlint:disable:next line_length
                Text("feedback.description.actualExample", comment: "Example of what actually happened")
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
