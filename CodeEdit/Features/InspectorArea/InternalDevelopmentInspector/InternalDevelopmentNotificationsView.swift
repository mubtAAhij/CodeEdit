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

        var localizedName: String {
            switch self {
            case .symbol:
                return String(localized: "internal-dev-notifications.icon-type-symbol", defaultValue: "Symbol", comment: "Icon type symbol")
            case .image:
                return String(localized: "internal-dev-notifications.icon-type-image", defaultValue: "Image", comment: "Icon type image")
            case .text:
                return String(localized: "internal-dev-notifications.icon-type-text", defaultValue: "Text", comment: "Icon type text")
            case .emoji:
                return String(localized: "internal-dev-notifications.icon-type-emoji", defaultValue: "Emoji", comment: "Icon type emoji")
            }
        }
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "internal-dev-notifications.action-view", defaultValue: "View", comment: "Default action button text")
    @State private var notificationTitle: String = String(localized: "internal-dev-notifications.test-title", defaultValue: "Test Notification", comment: "Default notification title")
    @State private var notificationDescription: String = String(localized: "internal-dev-notifications.test-description", defaultValue: "This is a test notification.", comment: "Default notification description")

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
        Section(String(localized: "internal-dev-notifications.section-title", defaultValue: "Notifications", comment: "Section title for notifications")) {
            Toggle(String(localized: "internal-dev-notifications.delay-5s", defaultValue: "Delay 5s", comment: "Toggle for 5 second delay"), isOn: $delay)
            Toggle(String(localized: "internal-dev-notifications.sticky", defaultValue: "Sticky", comment: "Toggle for sticky notifications"), isOn: $sticky)

            Picker(String(localized: "internal-dev-notifications.icon-type", defaultValue: "Icon Type", comment: "Picker label for icon type"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.localizedName).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "internal-dev-notifications.symbol-picker", defaultValue: "Symbol", comment: "Picker label for symbol selection"), selection: $selectedSymbol) {
                        Label(String(localized: "internal-dev-notifications.random", defaultValue: "Random", comment: "Random selection option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "internal-dev-notifications.emoji-picker", defaultValue: "Emoji", comment: "Picker label for emoji selection"), selection: $selectedEmoji) {
                        Label(String(localized: "internal-dev-notifications.random-emoji", defaultValue: "Random", comment: "Random emoji option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "internal-dev-notifications.text-picker", defaultValue: "Text", comment: "Picker label for text selection"), selection: $selectedText) {
                        Label(String(localized: "internal-dev-notifications.random-text", defaultValue: "Random", comment: "Random text option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "internal-dev-notifications.image-picker", defaultValue: "Image", comment: "Picker label for image selection"), selection: $selectedImage) {
                        Label(String(localized: "internal-dev-notifications.random-image", defaultValue: "Random", comment: "Random image option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "internal-dev-notifications.icon-color", defaultValue: "Icon Color", comment: "Picker label for icon color"), selection: $selectedColor) {
                        Label(String(localized: "internal-dev-notifications.random-color", defaultValue: "Random", comment: "Random color option"), systemImage: "dice").tag(nil as Color?)
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

            TextField(String(localized: "internal-dev-notifications.title-field", defaultValue: "Title", comment: "Text field for notification title"), text: $notificationTitle)
            TextField(String(localized: "internal-dev-notifications.description-field", defaultValue: "Description", comment: "Text field for notification description"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "internal-dev-notifications.action-button-field", defaultValue: "Action Button", comment: "Text field for action button text"), text: $actionButtonText)

            Button(String(localized: "internal-dev-notifications.add-notification", defaultValue: "Add Notification", comment: "Button to add notification")) {
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
