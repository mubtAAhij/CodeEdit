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
        let url = URL(fileURLWithPath: String(localized: "welcome.system.version.plist.path", defaultValue: "/System/Library/CoreServices/SystemVersion.plist", comment: "Path to macOS system version plist"))
        guard let dict = NSDictionary(contentsOf: url),
              let version = dict[String(localized: "welcome.product.user.visible.version", defaultValue: "ProductUserVisibleVersion", comment: "Product user visible version key")],
              let build = dict[String(localized: "welcome.product.build.version", defaultValue: "ProductBuildVersion", comment: "Product build version key")] else {
            return ProcessInfo.processInfo.operatingSystemVersionString
        }
        return String(format: String(localized: "welcome.version.build.format", defaultValue: "%@ (%@)", comment: "Version and build format"), String(describing: version), String(describing: build))
    }

    private var xcodeVersion: String? {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: String(localized: "welcome.xcode.bundle.id", defaultValue: "com.apple.dt.Xcode", comment: "Xcode bundle identifier")),
              let bundle = Bundle(url: url),
              let infoDict = bundle.infoDictionary,
              let version = infoDict[String(localized: "welcome.bundle.short.version", defaultValue: "CFBundleShortVersionString", comment: "Bundle short version key")] as? String,
              let buildURL = URL(string: String(format: String(localized: "welcome.xcode.version.plist.format", defaultValue: "%@Contents/version.plist", comment: "Xcode version plist path format"), url.absoluteString)),
              let buildDict = try? NSDictionary(contentsOf: buildURL, error: ()),
              let build = buildDict[String(localized: "welcome.product.build.version", defaultValue: "ProductBuildVersion", comment: "Product build version key")]
        else {
            return nil
        }
        return String(format: String(localized: "welcome.version.build.format", defaultValue: "%@ (%@)", comment: "Version and build format"), version, String(describing: build))
    }

    private func copyInformation() {
        var copyString = String(format: String(localized: "welcome.copy.app.info", defaultValue: "%@: %@%@ (%@)\n", comment: "App information format for clipboard"), Bundle.displayName, appVersion, appVersionPostfix, appBuild)
        copyString.append(String(format: String(localized: "welcome.copy.macos.info", defaultValue: "macOS: %@\n", comment: "macOS information format for clipboard"), macOSVersion))
        if let xcodeVersion { copyString.append(String(format: String(localized: "welcome.copy.xcode.info", defaultValue: "Xcode: %@", comment: "Xcode information format for clipboard"), xcodeVersion)) }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(copyString, forType: .string)
    }

    var body: some View {
        Text(String(
            format: String(localized: "welcome.version.display", defaultValue: "Version %@%@ (%@)", comment: "Welcome window version display format"),
            appVersion, appVersionPostfix, appBuild
        ))
        .textSelection(.enabled)
        .onHover { $0 ? NSCursor.pointingHand.push() : NSCursor.pop() }
        .onTapGesture { copyInformation() }
        .help(String(localized: "welcome.copy.tooltip", defaultValue: "Copy System Information to Clipboard", comment: "Tooltip for copying system information"))
    }
}
