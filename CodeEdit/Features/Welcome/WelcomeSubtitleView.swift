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
        return String(format: String(localized: "welcome.subtitle.version-build.short", defaultValue: "%@ (%@)", comment: "Short version and build string shown in welcome subtitle"), "\(version)", "\(build)")
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
        return String(format: String(localized: "welcome.subtitle.version-build.copy", defaultValue: "%@ (%@)", comment: "Version and build string used in copyable system info block"), "\(version)", "\(build)")
    }

    private func copyInformation() {
        var copyString = "\(Bundle.displayName): \(appVersion)\(appVersionPostfix) (\(appBuild))\n"
        copyString.append(String(format: String(localized: "welcome.subtitle.macos-version-line", defaultValue: "macOS: %@\n", comment: "Line showing macOS version in copyable system info"), "\(macOSVersion)"))
        if let xcodeVersion { copyString.append(String(format: String(localized: "welcome.subtitle.xcode-version-line", defaultValue: "Xcode: %@", comment: "Line showing Xcode version in copyable system info"), "\(xcodeVersion)")) }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(copyString, forType: .string)
    }

    var body: some View {
        Text(String(
            format: String(localized: "welcome.subtitle.version-label-with-postfix", defaultValue: "Version %@%@ (%@)", comment: "Formatted version label including postfix and build"),
            appVersion, appVersionPostfix, appBuild
        ))
        .textSelection(.enabled)
        .onHover { $0 ? NSCursor.pointingHand.push() : NSCursor.pop() }
        .onTapGesture { copyInformation() }
        .help(String(localized: "welcome.subtitle.copy-system-information", defaultValue: "Copy System Information to Clipboard", comment: "Button title to copy system information"))
    }
}
