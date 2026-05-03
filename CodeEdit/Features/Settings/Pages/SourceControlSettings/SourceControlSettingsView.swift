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

    @State var selectedTab: String = String(localized: "source_control_settings.tab.general", defaultValue: "general", comment: "General tab identifier")

    var body: some View {
        SettingsForm {
            Section {
                sourceControlIsEnabled
            } footer: {
                if settings.sourceControlIsEnabled {
                    Picker("", selection: $selectedTab) {
                        Text(String(localized: "source_control_settings.general", defaultValue: "General", comment: "General tab label")).tag(String(localized: "source_control_settings.tab.general", defaultValue: "general", comment: "General tab identifier"))
                        Text(String(localized: "source_control_settings.git", defaultValue: "Git", comment: "Git tab label")).tag(String(localized: "source_control_settings.tab.git", defaultValue: "git", comment: "Git tab identifier"))
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding(.top, 10)
                }
            }
            if settings.sourceControlIsEnabled {
                switch selectedTab {
                case String(localized: "source_control_settings.tab.general", defaultValue: "general", comment: "General tab identifier"):
                    SourceControlGeneralView()
                case String(localized: "source_control_settings.tab.git", defaultValue: "git", comment: "Git tab identifier"):
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
                Text(String(localized: "source_control_settings.title", defaultValue: "Source Control", comment: "Source Control settings title"))
                Text(String(localized: "source_control_settings.description", defaultValue: "Back up your files, collaborate with others, and tag your releases. [Learn more...](https://developer.apple.com/documentation/xcode/source-control-management)", comment: "Source Control settings description"))
                .font(.callout)
             } icon: {
                FeatureIcon(symbol: String(localized: "source_control_settings.icon", defaultValue: "vault", comment: "Source Control icon"), color: Color(.systemBlue), size: 26)
            }
        }
        .controlSize(.large)
    }

}
