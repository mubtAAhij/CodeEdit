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
                return String(localized: "internal-dev.notification.icon-type.symbol", defaultValue: "Symbol", comment: "Icon type option for SF Symbol")
            case .image:
                return String(localized: "internal-dev.notification.icon-type.image", defaultValue: "Image", comment: "Icon type option for image")
            case .text:
                return String(localized: "internal-dev.notification.icon-type.text", defaultValue: "Text", comment: "Icon type option for text")
            case .emoji:
                return String(localized: "internal-dev.notification.icon-type.emoji", defaultValue: "Emoji", comment: "Icon type option for emoji")
            }
        }
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = "View"
    @State private var notificationTitle: String = "Test Notification"
    @State private var notificationDescription: String = "This is a test notification."

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
        Section(String(localized: "internal-dev.notification.section-title", defaultValue: "Notifications", comment: "Section title for notification testing")) {
            Toggle(String(localized: "internal-dev.notification.delay-5s", defaultValue: "Delay 5s", comment: "Toggle to delay notification by 5 seconds"), isOn: $delay)
            Toggle(String(localized: "internal-dev.notification.sticky", defaultValue: "Sticky", comment: "Toggle to make notification persistent"), isOn: $sticky)

            Picker(String(localized: "internal-dev.notification.icon-type", defaultValue: "Icon Type", comment: "Label for icon type picker"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "internal-dev.notification.symbol", defaultValue: "Symbol", comment: "Label for symbol picker"), selection: $selectedSymbol) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Option to select random icon"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "internal-dev.notification.emoji", defaultValue: "Emoji", comment: "Label for emoji picker"), selection: $selectedEmoji) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Option to select random icon"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "internal-dev.notification.text", defaultValue: "Text", comment: "Label for text picker"), selection: $selectedText) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Option to select random icon"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "internal-dev.notification.image", defaultValue: "Image", comment: "Label for image picker"), selection: $selectedImage) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Option to select random icon"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "internal-dev.notification.icon-color", defaultValue: "Icon Color", comment: "Label for icon color picker"), selection: $selectedColor) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Option to select random icon"), systemImage: "dice").tag(nil as Color?)
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

            TextField(String(localized: "internal-dev.notification.title-field", defaultValue: "Title", comment: "Label for notification title field"), text: $notificationTitle)
            TextField(String(localized: "internal-dev.notification.description-field", defaultValue: "Description", comment: "Label for notification description field"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "internal-dev.notification.action-button-field", defaultValue: "Action Button", comment: "Label for action button text field"), text: $actionButtonText)

            Button(String(localized: "internal-dev.notification.add-button", defaultValue: "Add Notification", comment: "Button to add a test notification")) {
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
