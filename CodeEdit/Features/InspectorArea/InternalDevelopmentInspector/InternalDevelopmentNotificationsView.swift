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

        var displayName: String {
            switch self {
            case .symbol:
                return String(localized: "internal-dev.icon-type.symbol", defaultValue: "Symbol", comment: "Icon type for SF Symbol")
            case .image:
                return String(localized: "internal-dev.icon-type.image", defaultValue: "Image", comment: "Icon type for image")
            case .text:
                return String(localized: "internal-dev.icon-type.text", defaultValue: "Text", comment: "Icon type for text")
            case .emoji:
                return String(localized: "internal-dev.icon-type.emoji", defaultValue: "Emoji", comment: "Icon type for emoji")
            }
        }
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "internal-dev.action-button-default", defaultValue: "View", comment: "Default action button text for test notification")
    @State private var notificationTitle: String = String(localized: "internal-dev.notification-title-default", defaultValue: "Test Notification", comment: "Default title for test notification")
    @State private var notificationDescription: String = String(localized: "internal-dev.notification-description-default", defaultValue: "This is a test notification.", comment: "Default description for test notification")

    // Icon selection states
    @State private var selectedSymbol: String?
    @State private var selectedEmoji: String?
    @State private var selectedText: String?
    @State private var selectedImage: String?
    @State private var selectedColor: Color?

    private let availableSymbols = [
        "bell.fill",
        "bell.badge.fill",
        "exclamationmark.triangle.fill",
        "info.circle.fill",
        "checkmark.seal.fill",
        "xmark.octagon.fill",
        "bubble.left.fill",
        "envelope.fill",
        "phone.fill",
        "megaphone.fill",
        "clock.fill",
        "calendar",
        "flag.fill",
        "bookmark.fill",
        "bolt.fill",
        "shield.lefthalf.fill",
        "gift.fill",
        "heart.fill",
        "star.fill",
        "curlybraces"
    ]

    private let availableEmojis = [
        "🔔",
        "🚨",
        "⚠️",
        "👋",
        "😍",
        "😎",
        "😘",
        "😜",
        "😝",
        "😀",
        "😁",
        "😂",
        "🤣",
        "😃",
        "😄",
        "😅",
        "😆",
        "😇",
        "😉",
        "😊",
        "😋",
        "😌"
    ]

    private let availableImages = [
        "GitHubIcon",
        "BitBucketIcon",
        "GitLabIcon"
    ]

    private let availableColors: [(String, Color)] = [
        (String(localized: "internal-dev.color.red", defaultValue: "Red", comment: "Color name for red"), .red),
        (String(localized: "internal-dev.color.orange", defaultValue: "Orange", comment: "Color name for orange"), .orange),
        (String(localized: "internal-dev.color.yellow", defaultValue: "Yellow", comment: "Color name for yellow"), .yellow),
        (String(localized: "internal-dev.color.green", defaultValue: "Green", comment: "Color name for green"), .green),
        (String(localized: "internal-dev.color.mint", defaultValue: "Mint", comment: "Color name for mint"), .mint),
        (String(localized: "internal-dev.color.cyan", defaultValue: "Cyan", comment: "Color name for cyan"), .cyan),
        (String(localized: "internal-dev.color.teal", defaultValue: "Teal", comment: "Color name for teal"), .teal),
        (String(localized: "internal-dev.color.blue", defaultValue: "Blue", comment: "Color name for blue"), .blue),
        (String(localized: "internal-dev.color.indigo", defaultValue: "Indigo", comment: "Color name for indigo"), .indigo),
        (String(localized: "internal-dev.color.purple", defaultValue: "Purple", comment: "Color name for purple"), .purple),
        (String(localized: "internal-dev.color.pink", defaultValue: "Pink", comment: "Color name for pink"), .pink),
        (String(localized: "internal-dev.color.gray", defaultValue: "Gray", comment: "Color name for gray"), .gray)
    ]

    var body: some View {
        Section(String(localized: "internal-dev.section.notifications", defaultValue: "Notifications", comment: "Section header for notifications")) {
            Toggle(String(localized: "internal-dev.delay-toggle", defaultValue: "Delay 5s", comment: "Toggle to delay notification by 5 seconds"), isOn: $delay)
            Toggle(String(localized: "internal-dev.sticky-toggle", defaultValue: "Sticky", comment: "Toggle to make notification sticky"), isOn: $sticky)

            Picker(String(localized: "internal-dev.icon-type-picker", defaultValue: "Icon Type", comment: "Picker label for icon type"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "internal-dev.symbol-picker", defaultValue: "Symbol", comment: "Picker label for symbol selection"), selection: $selectedSymbol) {
                        Label(String(localized: "internal-dev.random-option", defaultValue: "Random", comment: "Random option label"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "internal-dev.emoji-picker", defaultValue: "Emoji", comment: "Picker label for emoji selection"), selection: $selectedEmoji) {
                        Label(String(localized: "internal-dev.random-option", defaultValue: "Random", comment: "Random option label"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "internal-dev.text-picker", defaultValue: "Text", comment: "Picker label for text selection"), selection: $selectedText) {
                        Label(String(localized: "internal-dev.random-option", defaultValue: "Random", comment: "Random option label"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "internal-dev.image-picker", defaultValue: "Image", comment: "Picker label for image selection"), selection: $selectedImage) {
                        Label(String(localized: "internal-dev.random-option", defaultValue: "Random", comment: "Random option label"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "internal-dev.icon-color-picker", defaultValue: "Icon Color", comment: "Picker label for icon color selection"), selection: $selectedColor) {
                        Label(String(localized: "internal-dev.random-option", defaultValue: "Random", comment: "Random option label"), systemImage: "dice").tag(nil as Color?)
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

            TextField(String(localized: "internal-dev.title-field", defaultValue: "Title", comment: "Placeholder for notification title field"), text: $notificationTitle)
            TextField(String(localized: "internal-dev.description-field", defaultValue: "Description", comment: "Placeholder for notification description field"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "internal-dev.action-button-field", defaultValue: "Action Button", comment: "Placeholder for action button text field"), text: $actionButtonText)

            Button(String(localized: "internal-dev.add-notification-button", defaultValue: "Add Notification", comment: "Button to add a test notification")) {
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
