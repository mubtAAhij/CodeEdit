//
//  InternalDevelopmentOutputView.swift
//  CodeEdit
//
//  Created by Khan Winter on 7/18/25.
//

import SwiftUI

struct InternalDevelopmentOutputView: View {
    var body: some View {
        Section(String(
            localized: "inspector.internal-development.output.output-utility",
            defaultValue: "Output Utility",
            comment: "Inspector tab label for output utility logs"
        )) {
            Button(String(
                localized: "inspector.internal-development.output.error-log",
                defaultValue: "Error Log",
                comment: "Inspector tab label for error log"
            )) {
                pushLog(.error)
            }
            Button(String(
                localized: "inspector.internal-development.output.warning-log",
                defaultValue: "Warning Log",
                comment: "Inspector tab label for warning log"
            )) {
                pushLog(.warning)
            }
            Button(String(
                localized: "inspector.internal-development.output.info-log",
                defaultValue: "Info Log",
                comment: "Inspector tab label for info log"
            )) {
                pushLog(.info)
            }
            Button(String(
                localized: "inspector.internal-development.output.debug-log",
                defaultValue: "Debug Log",
                comment: "Inspector tab label for debug log"
            )) {
                pushLog(.debug)
            }
        }

    }

    func pushLog(_ level: UtilityAreaLogLevel) {
        InternalDevelopmentOutputSource.shared.pushLog(
            .init(
                message: randomString(),
                subsystem: "internal.development",
                category: String(
                    localized: "inspector.internal-development.output.logs",
                    defaultValue: "Logs",
                    comment: "Section title for internal development logs"
                ),
                level: level
            )
        )
    }

    func randomString() -> String {
        let strings = ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce molestie, dui et consectetur"
        + "porttitor, orci lectus fermentum augue, eu faucibus lectus nisl id velit. Suspendisse in mi nunc. Aliquam"
        + "non dolor eu eros mollis euismod. Praesent mollis mauris at ex dapibus ornare. Ut imperdiet"
        + "finibus lacus ut aliquam. Vivamus semper, mauris in condimentum volutpat, quam erat eleifend ligula,"
        + "nec tincidunt sem ante et ex. Sed dui magna, placerat quis orci at, bibendum molestie massa. Maecenas"
        + "velit nunc, vehicula eu venenatis vel, tincidunt id purus. Morbi eu dignissim arcu, sed ornare odio."
        + "Nam vestibulum tempus nibh id finibus.").split(separator: " ")
        let count = Int.random(in: 0..<25)
        return (0..<count).compactMap { _ in
            strings.randomElement()
        }
        .joined(separator: " ")
    }
}
