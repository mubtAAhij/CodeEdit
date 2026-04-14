//
//  AboutSubtitleView.swift
//  CodeEdit
//
//  Created by Giorgi Tchelidze on 08.06.25.
//

import SwiftUI

struct AboutSubtitleView: View {

    @State private var didCopyVersion = false
    @State private var isHoveringVersion = false

    private var appVersion: String { Bundle.versionString ?? String(localized: "about.no-version", defaultValue: "No Version", comment: "Fallback when version unavailable") }
    private var appBuild: String { Bundle.buildString ?? String(localized: "about.no-build", defaultValue: "No Build", comment: "Fallback when build unavailable") }
    private var appVersionPostfix: String { Bundle.versionPostfix ?? "" }

    var body: some View {
        Text(String(format: String(localized: "about.version-format", defaultValue: "Version %@%@ (%@)", comment: "Version format string"), appVersion, appVersionPostfix, appBuild))
            .textSelection(.disabled)
            .onTapGesture {
                // Create a string suitable for pasting into a bug report
                let macOSVersion = ProcessInfo.processInfo.operatingSystemVersion.semverString
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(
                    String(format: String(localized: "about.system-info-format", defaultValue: "CodeEdit: %@ (%@)\nmacOS: %@", comment: "System information format string"), appVersion, appBuild, macOSVersion),
                    forType: .string
                )
                didCopyVersion.toggle()
            }
            .background(alignment: .leading) {
                if isHoveringVersion {
                    if #available(macOS 14.0, *) {
                        Image(systemName: "document.on.document.fill")
                            .font(.caption)
                            .offset(x: -16, y: 0)
                            .transition(.opacity)
                            .symbolEffect(
                                .bounce.down.wholeSymbol,
                                options: .nonRepeating.speed(1.8),
                                value: didCopyVersion
                            )
                    } else {
                        Image(systemName: "document.on.document.fill")
                            .font(.caption)
                            .offset(x: -16, y: 0)
                            .transition(.opacity)
                    }
                }
            }
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isHoveringVersion = hovering
                }
            }
    }
}
