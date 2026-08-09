//
//  InternalDevelopmentNotificationsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 2/19/24.
//

import SwiftUI

struct InternalDevelopmentNotificationsView: View {
    enum IconType: String, CaseIterable {
        case symbol = String(localized: "inspector.internal-development.notifications.icon-type.symbol", defaultValue: "Symbol", comment: "Picker option for symbol notification icon type.")
        case image = String(localized: "inspector.internal-development.notifications.icon-type.image", defaultValue: "Image", comment: "Picker option for image notification icon type.")
        case text = String(localized: "inspector.internal-development.notifications.icon-type.text", defaultValue: "Text", comment: "Picker option for text notification icon type.")
        case emoji = String(localized: "inspector.internal-development.notifications.icon-type.emoji", defaultValue: "Emoji", comment: "Picker option for emoji notification icon type.")
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "inspector.internal-development.notifications.icon-type.view", defaultValue: "View", comment: "Picker option for custom view notification icon type.")
    @State private var notificationTitle: String = String(localized: "inspector.internal-development.notifications.test.title", defaultValue: "Test Notification", comment: "Title used for internal test notification.")
    @State private var notificationDescription: String = String(localized: "inspector.internal-development.notifications.test.message", defaultValue: "This is a test notification.", comment: "Body text used for internal test notification.")

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
        Section(String(localized: "inspector.internal-development.notifications.section-title", defaultValue: "Notifications", comment: "Section title for internal development notifications controls.")) {
            Toggle(String(localized: "inspector.internal-development.notifications.delay-5s", defaultValue: "Delay 5s", comment: "Toggle label to delay test notification by five seconds."), isOn: $delay)
            Toggle(String(localized: "inspector.internal-development.notifications.sticky", defaultValue: "Sticky", comment: "Toggle label to make test notification sticky."), isOn: $sticky)

            Picker(String(localized: "inspector.internal-development.notifications.icon-type.label", defaultValue: "Icon Type", comment: "Label for notification icon type picker."), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker("Symbol", selection: $selectedSymbol) {
                        Label("Random", systemImage: String(localized: "inspector.internal-development.notifications.icon-options.random.dice-label.symbol", defaultValue: "dice", comment: "Text label describing random dice icon for symbol option.")).tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "inspector.internal-development.notifications.icon-options.emoji.section", defaultValue: "Emoji", comment: "Section title for emoji icon options."), selection: $selectedEmoji) {
                        Label(String(localized: "inspector.internal-development.notifications.icon-options.emoji.random", defaultValue: "Random", comment: "Button title to choose random emoji icon."), systemImage: String(localized: "inspector.internal-development.notifications.icon-options.random.dice-label.emoji", defaultValue: "dice", comment: "Text label describing random dice icon for emoji option.")).tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "inspector.internal-development.notifications.icon-options.text.section", defaultValue: "Text", comment: "Section title for text icon options."), selection: $selectedText) {
                        Label(String(localized: "inspector.internal-development.notifications.icon-options.text.random", defaultValue: "Random", comment: "Button title to choose random text icon."), systemImage: String(localized: "inspector.internal-development.notifications.icon-options.random.dice-label.text", defaultValue: "dice", comment: "Text label describing random dice icon for text option.")).tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "inspector.internal-development.notifications.icon-options.image.section", defaultValue: "Image", comment: "Section title for image icon options."), selection: $selectedImage) {
                        Label(String(localized: "inspector.internal-development.notifications.icon-options.image.random", defaultValue: "Random", comment: "Button title to choose random image icon."), systemImage: String(localized: "inspector.internal-development.notifications.icon-options.random.dice-label.image", defaultValue: "dice", comment: "Text label describing random dice icon for image option.")).tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "inspector.internal-development.notifications.icon-color.label", defaultValue: "Icon Color", comment: "Label for icon color picker."), selection: $selectedColor) {
                        Label(String(localized: "inspector.internal-development.notifications.icon-color.random", defaultValue: "Random", comment: "Button title to choose random icon color."), systemImage: String(localized: "inspector.internal-development.notifications.icon-color.random.dice-label", defaultValue: "dice", comment: "Text label describing random dice icon for icon color option.")).tag(nil as Color?)
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

            TextField(String(localized: "inspector.internal-development.notifications.fields.title", defaultValue: "Title", comment: "Label for notification title input field."), text: $notificationTitle)
            TextField(String(localized: "inspector.internal-development.notifications.fields.description", defaultValue: "Description", comment: "Label for notification description input field."), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "inspector.internal-development.notifications.fields.action-button", defaultValue: "Action Button", comment: "Label for notification action button input field."), text: $actionButtonText)

            Button(String(localized: "inspector.internal-development.notifications.actions.add-notification", defaultValue: "Add Notification", comment: "Button title to create a notification from internal development inspector.")) {
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
