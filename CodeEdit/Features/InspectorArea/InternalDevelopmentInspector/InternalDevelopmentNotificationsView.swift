//
//  InternalDevelopmentNotificationsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 2/19/24.
//

import SwiftUI

struct InternalDevelopmentNotificationsView: View {
    enum IconType: String, CaseIterable {
        case symbol = "Symbol"
        case image = "Image"
        case text = "Text"
        case emoji = "Emoji"
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "dev-notifications.action-button", defaultValue: "View", comment: "Default action button text")
    @State private var notificationTitle: String = String(localized: "dev-notifications.test-title", defaultValue: "Test Notification", comment: "Default test notification title")
    @State private var notificationDescription: String = String(localized: "dev-notifications.test-description", defaultValue: "This is a test notification.", comment: "Default test notification description")

    // Icon selection states
    @State private var selectedSymbol: String?
    @State private var selectedEmoji: String?
    @State private var selectedText: String?
    @State private var selectedImage: String?
    @State private var selectedColor: Color?

    private let availableSymbols = [
        "bell.fill", "bell.badge.fill", "exclamationmark.triangle.fill",
        "info.circle.fill", "checkmark.seal.fill", "xmark.octagon.fill",
        "bubble.left.fill", "envelope.fill", "phone.fill", "megaphone.fill",
        "clock.fill", "calendar", "flag.fill", "bookmark.fill", "bolt.fill",
        "shield.lefthalf.fill", "gift.fill", "heart.fill", "star.fill",
        "curlybraces"
    ]

    private let availableEmojis = [
        "🔔", "🚨", "⚠️", "👋", "😍", "😎", "😘", "😜", "😝", "😀", "😁",
        "😂", "🤣", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "😋", "😌"
    ]

    private let availableImages = [
        "GitHubIcon", "BitBucketIcon", "GitLabIcon"
    ]

    private let availableColors: [(String, Color)] = [
        ("Red", .red), ("Orange", .orange), ("Yellow", .yellow),
        ("Green", .green), ("Mint", .mint), ("Cyan", .cyan),
        ("Teal", .teal), ("Blue", .blue), ("Indigo", .indigo),
        ("Purple", .purple), ("Pink", .pink), ("Gray", .gray)
    ]

    var body: some View {
        Section(String(localized: "dev-notifications.section", defaultValue: "Notifications", comment: "Section header for notifications settings")) {
            Toggle(String(localized: "dev-notifications.delay", defaultValue: "Delay 5s", comment: "Toggle to delay notification by 5 seconds"), isOn: $delay)
            Toggle(String(localized: "dev-notifications.sticky", defaultValue: "Sticky", comment: "Toggle to make notification sticky"), isOn: $sticky)

            Picker(String(localized: "dev-notifications.icon-type", defaultValue: "Icon Type", comment: "Picker for icon type"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "dev-notifications.icon-type.symbol", defaultValue: "Symbol", comment: "Picker for symbol icon"), selection: $selectedSymbol) {
                        Label(String(localized: "dev-notifications.random", defaultValue: "Random", comment: "Option for random selection"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "dev-notifications.icon-type.emoji", defaultValue: "Emoji", comment: "Picker for emoji icon"), selection: $selectedEmoji) {
                        Label(String(localized: "dev-notifications.random", defaultValue: "Random", comment: "Option for random selection"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "dev-notifications.icon-type.text", defaultValue: "Text", comment: "Picker for text icon"), selection: $selectedText) {
                        Label(String(localized: "dev-notifications.random", defaultValue: "Random", comment: "Option for random selection"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "dev-notifications.icon-type.image", defaultValue: "Image", comment: "Picker for image icon"), selection: $selectedImage) {
                        Label(String(localized: "dev-notifications.random", defaultValue: "Random", comment: "Option for random selection"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "dev-notifications.icon-color", defaultValue: "Icon Color", comment: "Picker for icon color"), selection: $selectedColor) {
                        Label(String(localized: "dev-notifications.random", defaultValue: "Random", comment: "Option for random selection"), systemImage: "dice").tag(nil as Color?)
                        Divider()
                        ForEach(availableColors, id: \.0) { name, color in
                            HStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 12, height: 12)
                                Text(name)
                            }.tag(color as Color?)
                        }
                    }
                }
            }

            TextField(String(localized: "dev-notifications.title-field", defaultValue: "Title", comment: "Placeholder for notification title field"), text: $notificationTitle)
            TextField(String(localized: "dev-notifications.description-field", defaultValue: "Description", comment: "Placeholder for notification description field"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "dev-notifications.action-button-field", defaultValue: "Action Button", comment: "Placeholder for action button text field"), text: $actionButtonText)

            Button(String(localized: "dev-notifications.add-button", defaultValue: "Add Notification", comment: "Button to add a test notification")) {
                let action = {
                    switch selectedIconType {
                    case .symbol:
                        let iconSymbol = selectedSymbol ?? availableSymbols.randomElement() ?? "bell.fill"
                        let iconColor = selectedColor ?? availableColors.randomElement()?.1 ?? .blue

                        NotificationManager.shared.post(
                            iconSymbol: iconSymbol,
                            iconColor: iconColor,
                            title: notificationTitle,
                            description: notificationDescription,
                            actionButtonTitle: actionButtonText,
                            action: {
                                print("Test notification action triggered")
                            },
                            isSticky: sticky
                        )
                    case .image:
                        let imageName = selectedImage ?? availableImages.randomElement() ?? "GitHubIcon"

                        NotificationManager.shared.post(
                            iconImage: Image(imageName),
                            title: notificationTitle,
                            description: notificationDescription,
                            actionButtonTitle: actionButtonText,
                            action: {
                                print("Test notification action triggered")
                            },
                            isSticky: sticky
                        )
                    case .text:
                        let text = selectedText ?? randomLetter()
                        let iconColor = selectedColor ?? availableColors.randomElement()?.1 ?? .blue

                        NotificationManager.shared.post(
                            iconText: text,
                            iconTextColor: .white,
                            iconColor: iconColor,
                            title: notificationTitle,
                            description: notificationDescription,
                            actionButtonTitle: actionButtonText,
                            action: {
                                print("Test notification action triggered")
                            },
                            isSticky: sticky
                        )
                    case .emoji:
                        let emoji = selectedEmoji ?? availableEmojis.randomElement() ?? "🔔"
                        let iconColor = selectedColor ?? availableColors.randomElement()?.1 ?? .blue

                        NotificationManager.shared.post(
                            iconText: emoji,
                            iconTextColor: .white,
                            iconColor: iconColor,
                            title: notificationTitle,
                            description: notificationDescription,
                            actionButtonTitle: actionButtonText,
                            action: {
                                print("Test notification action triggered")
                            },
                            isSticky: sticky
                        )
                    }
                }

                if delay {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        action()
                    }
                } else {
                    action()
                }
            }
        }
    }

    private func randomLetter() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
        return letters.randomElement() ?? "A"
    }
}
