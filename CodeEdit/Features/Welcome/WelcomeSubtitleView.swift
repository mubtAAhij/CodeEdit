//
//  WelcomeSubtitleView.swift
//  CodeEdit
//
//  Created by Giorgi Tchelidze on 07.06.25.
//

import SwiftUI
import WelcomeWindow

struct WelcomeSubtitleView: View {

    private var appVersion: String { Bundle.versionString ?? "" }
    private var appBuild: String { Bundle.buildString ?? "" }
    private var appVersionPostfix: String { Bundle.versionPostfix ?? "" }

    private var macOSVersion: String {
        let url = URL(fileURLWithPath: "/System/Library/CoreServices/SystemVersion.plist")
        guard let dict = NSDictionary(contentsOf: url),
              let version = dict["ProductUserVisibleVersion"],
              let build = dict["ProductBuildVersion"] else {
            return ProcessInfo.processInfo.operatingSystemVersionString
        }
        return "\(version) (\(build))"
    }

    private var xcodeVersion: String? {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.dt.Xcode"),
              let bundle = Bundle(url: url),
              let infoDict = bundle.infoDictionary,
              let version = infoDict["CFBundleShortVersionString"] as? String,
              let buildURL = URL(string: "\(url)Contents/version.plist"),
              let buildDict = try? NSDictionary(contentsOf: buildURL, error: ()),
              let build = buildDict["ProductBuildVersion"]
        else {
            return nil
        }
        return "\(version) (\(build))"
    }

    private func copyInformation() {
        var copyString = String(format: String(localized: "welcome.subtitle.app-info", defaultValue: "%@: %@%@ (%@)\n", comment: "App info line for clipboard, first %@ is app name, second %@ is version, third %@ is postfix, fourth %@ is build"), Bundle.displayName, appVersion, appVersionPostfix, appBuild)
        copyString.append(String(format: String(localized: "welcome.subtitle.macos-info", defaultValue: "macOS: %@\n", comment: "macOS info line for clipboard, %@ is macOS version"), macOSVersion))
        if let xcodeVersion { copyString.append(String(format: String(localized: "welcome.subtitle.xcode-info", defaultValue: "Xcode: %@", comment: "Xcode info line for clipboard, %@ is Xcode version"), xcodeVersion)) }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(copyString, forType: .string)
    }

    var body: some View {
        Text(String(
            format: String(localized: "welcome.subtitle.version", defaultValue: "Version %@%@ (%@)", comment: "Version text format, first %@ is version, second %@ is postfix, third %@ is build"),
            appVersion, appVersionPostfix, appBuild
        ))
        .textSelection(.enabled)
        .onHover { $0 ? NSCursor.pointingHand.push() : NSCursor.pop() }
        .onTapGesture { copyInformation() }
        .help(String(localized: "welcome.subtitle.copy-help", defaultValue: "Copy System Information to Clipboard", comment: "Tooltip for copying system information"))
    }
}
