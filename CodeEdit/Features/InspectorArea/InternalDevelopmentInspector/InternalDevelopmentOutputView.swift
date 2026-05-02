//
//  InternalDevelopmentOutputView.swift
//  CodeEdit
//
//  Created by Khan Winter on 7/18/25.
//

import SwiftUI

struct InternalDevelopmentOutputView: View {
    var body: some View {
        Section(String(localized: "internal-development.output-utility", defaultValue: "Output Utility", comment: "Output utility section header")) {
            Button(String(localized: "internal-development.error-log", defaultValue: "Error Log", comment: "Error log button")) {
                pushLog(.error)
            }
            Button(String(localized: "internal-development.warning-log", defaultValue: "Warning Log", comment: "Warning log button")) {
                pushLog(.warning)
            }
            Button(String(localized: "internal-development.info-log", defaultValue: "Info Log", comment: "Info log button")) {
                pushLog(.info)
            }
            Button(String(localized: "internal-development.debug-log", defaultValue: "Debug Log", comment: "Debug log button")) {
                pushLog(.debug)
            }
        }

    }

    func pushLog(_ level: UtilityAreaLogLevel) {
        InternalDevelopmentOutputSource.shared.pushLog(
            .init(
                message: randomString(),
                subsystem: String(localized: "internal-development.subsystem", defaultValue: "internal.development", comment: "Internal development subsystem identifier"),
                category: String(localized: "internal-development.logs-category", defaultValue: "Logs", comment: "Logs category"),
                level: level
            )
        )
    }

    func randomString() -> String {
        let strings = (String(localized: "internal-development.lorem-ipsum", defaultValue: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce molestie, dui et consecteturporttitor, orci lectus fermentum augue, eu faucibus lectus nisl id velit. Suspendisse in mi nunc. Aliquamnon dolor eu eros mollis euismod. Praesent mollis mauris at ex dapibus ornare. Ut imperdietfinibus lacus ut aliquam. Vivamus semper, mauris in condimentum volutpat, quam erat eleifend ligula,nec tincidunt sem ante et ex. Sed dui magna, placerat quis orci at, bibendum molestie massa. Maecenasvelit nunc, vehicula eu venenatis vel, tincidunt id purus. Morbi eu dignissim arcu, sed ornare odio.Nam vestibulum tempus nibh id finibus.", comment: "Lorem ipsum placeholder text")).split(separator: " ")
        let count = Int.random(in: 0..<25)
        return (0..<count).compactMap { _ in
            strings.randomElement()
        }
        .joined(separator: " ")
    }
}
