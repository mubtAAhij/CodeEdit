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
    @State private var actionButtonText: String = String(localized: "inspector.internal-dev.notifications.view", defaultValue: "View", comment: "View action button text")
    @State private var notificationTitle: String = String(localized: "inspector.internal-dev.notifications.test-title", defaultValue: "Test Notification", comment: "Test notification title")
    @State private var notificationDescription: String = String(localized: "inspector.internal-dev.notifications.test-description", defaultValue: "This is a test notification.", comment: "Test notification description")

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

    private var availableColors: [(String, Color)] {
        [
            (String(localized: "inspector.internal-dev.notifications.color.red", defaultValue: "Red", comment: "Red color option"), .red),
            (String(localized: "inspector.internal-dev.notifications.color.orange", defaultValue: "Orange", comment: "Orange color option"), .orange),
            (String(localized: "inspector.internal-dev.notifications.color.yellow", defaultValue: "Yellow", comment: "Yellow color option"), .yellow),
            (String(localized: "inspector.internal-dev.notifications.color.green", defaultValue: "Green", comment: "Green color option"), .green),
            (String(localized: "inspector.internal-dev.notifications.color.mint", defaultValue: "Mint", comment: "Mint color option"), .mint),
            (String(localized: "inspector.internal-dev.notifications.color.cyan", defaultValue: "Cyan", comment: "Cyan color option"), .cyan),
            (String(localized: "inspector.internal-dev.notifications.color.teal", defaultValue: "Teal", comment: "Teal color option"), .teal),
            (String(localized: "inspector.internal-dev.notifications.color.blue", defaultValue: "Blue", comment: "Blue color option"), .blue),
            (String(localized: "inspector.internal-dev.notifications.color.indigo", defaultValue: "Indigo", comment: "Indigo color option"), .indigo),
            (String(localized: "inspector.internal-dev.notifications.color.purple", defaultValue: "Purple", comment: "Purple color option"), .purple),
            (String(localized: "inspector.internal-dev.notifications.color.pink", defaultValue: "Pink", comment: "Pink color option"), .pink),
            (String(localized: "inspector.internal-dev.notifications.color.gray", defaultValue: "Gray", comment: "Gray color option"), .gray)
        ]
    }

    var body: some View {
        Section(String(localized: "inspector.internal-dev.notifications.section", defaultValue: "Notifications", comment: "Notifications section header")) {
            Toggle(String(localized: "inspector.internal-dev.notifications.delay", defaultValue: "Delay 5s", comment: "Toggle for 5 second delay"), isOn: $delay)
            Toggle(String(localized: "inspector.internal-dev.notifications.sticky", defaultValue: "Sticky", comment: "Toggle for sticky notifications"), isOn: $sticky)

            Picker(String(localized: "inspector.internal-dev.notifications.icon-type", defaultValue: "Icon Type", comment: "Picker for icon type"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "inspector.internal-dev.notifications.symbol", defaultValue: "Symbol", comment: "Symbol picker label"), selection: $selectedSymbol) {
                        Label(String(localized: "inspector.internal-dev.notifications.random", defaultValue: "Random", comment: "Random option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "inspector.internal-dev.notifications.emoji", defaultValue: "Emoji", comment: "Emoji picker label"), selection: $selectedEmoji) {
                        Label(String(localized: "inspector.internal-dev.notifications.random", defaultValue: "Random", comment: "Random option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "inspector.internal-dev.notifications.text", defaultValue: "Text", comment: "Text picker label"), selection: $selectedText) {
                        Label(String(localized: "inspector.internal-dev.notifications.random", defaultValue: "Random", comment: "Random option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "inspector.internal-dev.notifications.image", defaultValue: "Image", comment: "Image picker label"), selection: $selectedImage) {
                        Label(String(localized: "inspector.internal-dev.notifications.random", defaultValue: "Random", comment: "Random option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "inspector.internal-dev.notifications.icon-color", defaultValue: "Icon Color", comment: "Icon color picker label"), selection: $selectedColor) {
                        Label(String(localized: "inspector.internal-dev.notifications.random", defaultValue: "Random", comment: "Random option"), systemImage: "dice").tag(nil as Color?)
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

            TextField(String(localized: "inspector.internal-dev.notifications.title-field", defaultValue: "Title", comment: "Title text field label"), text: $notificationTitle)
            TextField(String(localized: "inspector.internal-dev.notifications.description-field", defaultValue: "Description", comment: "Description text field label"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "inspector.internal-dev.notifications.action-button-field", defaultValue: "Action Button", comment: "Action button text field label"), text: $actionButtonText)

            Button(String(localized: "inspector.internal-dev.notifications.add-notification", defaultValue: "Add Notification", comment: "Button to add notification")) {
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
