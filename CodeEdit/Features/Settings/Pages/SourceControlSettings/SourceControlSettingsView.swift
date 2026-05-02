//
//  SourceControlSettingsView.swift
//  CodeEdit
//
//  Created by Raymond Vleeshouwer on 02/04/23.
//

import SwiftUI

struct SourceControlSettingsView: View {
    @AppSettings(\.sourceControl.general)
    var settings

    @State var selectedTab: String = String(localized: "settings.sourcecontrol.tab.general.id", defaultValue: "general", comment: "General tab identifier (technical constant, should not be localized)")

    var body: some View {
        SettingsForm {
            Section {
                sourceControlIsEnabled
            } footer: {
                if settings.sourceControlIsEnabled {
                    Picker("", selection: $selectedTab) {
                        Text(String(localized: "settings.sourcecontrol.tab.general", defaultValue: "General", comment: "General tab label")).tag(String(localized: "settings.sourcecontrol.tab.general.id", defaultValue: "general", comment: "General tab identifier (technical constant, should not be localized)"))
                        Text(String(localized: "settings.sourcecontrol.tab.git", defaultValue: "Git", comment: "Git tab label")).tag(String(localized: "settings.sourcecontrol.tab.git.id", defaultValue: "git", comment: "Git tab identifier (technical constant, should not be localized)"))
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding(.top, 10)
                }
            }
            if settings.sourceControlIsEnabled {
                switch selectedTab {
                case String(localized: "settings.sourcecontrol.tab.general.id", defaultValue: "general", comment: "General tab identifier (technical constant, should not be localized)"):
                    SourceControlGeneralView()
                case String(localized: "settings.sourcecontrol.tab.git.id", defaultValue: "git", comment: "Git tab identifier (technical constant, should not be localized)"):
                    SourceControlGitView()
                default:
                    SourceControlGeneralView()
                }
            }
        }
    }

    private var sourceControlIsEnabled: some View {
        Toggle(
            isOn: $settings.sourceControlIsEnabled
        ) {
            Label {
                Text(String(localized: "settings.sourcecontrol.title", defaultValue: "Source Control", comment: "Source Control settings title"))
                Text(String(localized: "settings.sourcecontrol.description", defaultValue: "Back up your files, collaborate with others, and tag your releases. [Learn more...](https://developer.apple.com/documentation/xcode/source-control-management)", comment: "Source Control settings description"))
                .font(.callout)
             } icon: {
                FeatureIcon(symbol: "vault", color: Color(.systemBlue), size: 26)
            }
        }
        .controlSize(.large)
    }

}
