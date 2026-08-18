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
    @State private var actionButtonText: String = String(
        localized: "inspector.internal-development.notifications.view-title",
        defaultValue: "View",
        comment: "Internal development notifications view title"
    )
    @State private var notificationTitle: String = String(
        localized: "inspector.internal-development.notifications.test-notification.title",
        defaultValue: "Test Notification",
        comment: "Title for test notification preview"
    )
    @State private var notificationDescription: String = String(
        localized: "inspector.internal-development.notifications.test-notification.message",
        defaultValue: "This is a test notification.",
        comment: "Body text for test notification preview"
    )

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
        (String(
            localized: "inspector.internal-development.notifications.color.red",
            defaultValue: "Red",
            comment: "Notification color option red"
        ), .red), (String(
            localized: "inspector.internal-development.notifications.color.orange",
            defaultValue: "Orange",
            comment: "Notification color option orange"
        ), .orange), (String(
            localized: "inspector.internal-development.notifications.color.yellow",
            defaultValue: "Yellow",
            comment: "Notification color option yellow"
        ), .yellow),
        (String(
            localized: "inspector.internal-development.notifications.color.green",
            defaultValue: "Green",
            comment: "Notification color option green"
        ), .green), (String(
            localized: "inspector.internal-development.notifications.color.mint",
            defaultValue: "Mint",
            comment: "Notification color option mint"
        ), .mint), (String(
            localized: "inspector.internal-development.notifications.color.cyan",
            defaultValue: "Cyan",
            comment: "Notification color option cyan"
        ), .cyan),
        (String(
            localized: "inspector.internal-development.notifications.color.teal",
            defaultValue: "Teal",
            comment: "Notification color option teal"
        ), .teal), (String(
            localized: "inspector.internal-development.notifications.color.blue",
            defaultValue: "Blue",
            comment: "Notification color option blue"
        ), .blue), (String(
            localized: "inspector.internal-development.notifications.color.indigo",
            defaultValue: "Indigo",
            comment: "Notification color option indigo"
        ), .indigo),
        (String(
            localized: "inspector.internal-development.notifications.color.purple",
            defaultValue: "Purple",
            comment: "Notification color option purple"
        ), .purple), (String(
            localized: "inspector.internal-development.notifications.color.pink",
            defaultValue: "Pink",
            comment: "Notification color option pink"
        ), .pink), (String(
            localized: "inspector.internal-development.notifications.color.gray",
            defaultValue: "Gray",
            comment: "Notification color option gray"
        ), .gray)
    ]

    var body: some View {
        Section(String(
            localized: "inspector.internal-development.notifications.section-title",
            defaultValue: "Notifications",
            comment: "Section title for internal development notification controls"
        )) {
            Toggle(String(
                localized: "inspector.internal-development.notifications.delay-5s",
                defaultValue: "Delay 5s",
                comment: "Notification timing option for delaying by five seconds"
            ), isOn: $delay)
            Toggle(String(
                localized: "inspector.internal-development.notifications.sticky",
                defaultValue: "Sticky",
                comment: "Notification timing option for sticky notification"
            ), isOn: $sticky)

            Picker(String(
                localized: "inspector.internal-development.notifications.icon-type",
                defaultValue: "Icon Type",
                comment: "Section label for selecting notification icon type"
            ), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-type.symbol-option",
                        defaultValue: "Symbol",
                        comment: "Option label for symbol icon type"
                    ), selection: $selectedSymbol) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.symbol.random",
                            defaultValue: "Random",
                            comment: "Option label for random symbol icon"
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-type.emoji-option",
                        defaultValue: "Emoji",
                        comment: "Option label for emoji icon type"
                    ), selection: $selectedEmoji) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.emoji.random",
                            defaultValue: "Random",
                            comment: "Option label for random emoji icon"
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-type.text-option",
                        defaultValue: "Text",
                        comment: "Option label for text icon type"
                    ), selection: $selectedText) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.text.random",
                            defaultValue: "Random",
                            comment: "Option label for random text icon"
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-type.image-option",
                        defaultValue: "Image",
                        comment: "Option label for image icon type"
                    ), selection: $selectedImage) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.image.random",
                            defaultValue: "Random",
                            comment: "Option label for random image icon"
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-color",
                        defaultValue: "Icon Color",
                        comment: "Section label for notification icon color"
                    ), selection: $selectedColor) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-color.random",
                            defaultValue: "Random",
                            comment: "Option label for random icon color"
                        ), systemImage: "dice").tag(nil as Color?)
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

            TextField(String(
                localized: "inspector.internal-development.notifications.title",
                defaultValue: "Title",
                comment: "Input label for notification title"
            ), text: $notificationTitle)
            TextField(String(
                localized: "inspector.internal-development.notifications.description",
                defaultValue: "Description",
                comment: "Input label for notification description"
            ), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(
                localized: "inspector.internal-development.notifications.action-button",
                defaultValue: "Action Button",
                comment: "Toggle label for showing notification action button"
            ), text: $actionButtonText)

            Button(String(
                localized: "inspector.internal-development.notifications.add-notification",
                defaultValue: "Add Notification",
                comment: "Button title to add a test notification"
            )) {
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
                        let imageName = selectedImage ?? availableImages.randomElement() ?? String(
                            localized: "inspector.internal-development.notifications.icon.github-icon",
                            defaultValue: "GitHubIcon",
                            comment: "Icon name option shown in internal development notifications inspector"
                        )

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
