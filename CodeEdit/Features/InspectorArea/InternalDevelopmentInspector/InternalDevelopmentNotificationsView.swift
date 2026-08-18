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
        localized: "inspector.internal-development.notifications.view.title",
        defaultValue: "View",
        comment: "Label for previewing notification view style"
    )
    @State private var notificationTitle: String = String(
        localized: "inspector.internal-development.notifications.test-notification.title",
        defaultValue: "Test Notification",
        comment: "Title text for generated test notification"
    )
    @State private var notificationDescription: String = String(
        localized: "inspector.internal-development.notifications.test-notification.message",
        defaultValue: "This is a test notification.",
        comment: "Body message for generated test notification"
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
            localized: "inspector.internal-development.notifications.color.red.option",
            defaultValue: "Red",
            comment: "Color option label for red notification tint"
        ), .red), (String(
            localized: "inspector.internal-development.notifications.color.orange.option",
            defaultValue: "Orange",
            comment: "Color option label for orange notification tint"
        ), .orange), (String(
            localized: "inspector.internal-development.notifications.color.yellow.option",
            defaultValue: "Yellow",
            comment: "Color option label for yellow notification tint"
        ), .yellow),
        (String(
            localized: "inspector.internal-development.notifications.color.green.option",
            defaultValue: "Green",
            comment: "Color option label for green notification tint"
        ), .green), (String(
            localized: "inspector.internal-development.notifications.color.mint.option",
            defaultValue: "Mint",
            comment: "Color option label for mint notification tint"
        ), .mint), (String(
            localized: "inspector.internal-development.notifications.color.cyan.option",
            defaultValue: "Cyan",
            comment: "Color option label for cyan notification tint"
        ), .cyan),
        (String(
            localized: "inspector.internal-development.notifications.color.teal.option",
            defaultValue: "Teal",
            comment: "Color option label for teal notification tint"
        ), .teal), (String(
            localized: "inspector.internal-development.notifications.color.blue.option",
            defaultValue: "Blue",
            comment: "Color option label for blue notification tint"
        ), .blue), (String(
            localized: "inspector.internal-development.notifications.color.indigo.option",
            defaultValue: "Indigo",
            comment: "Color option label for indigo notification tint"
        ), .indigo),
        (String(
            localized: "inspector.internal-development.notifications.color.purple.option",
            defaultValue: "Purple",
            comment: "Color option label for purple notification tint"
        ), .purple), (String(
            localized: "inspector.internal-development.notifications.color.pink.option",
            defaultValue: "Pink",
            comment: "Color option label for pink notification tint"
        ), .pink), (String(
            localized: "inspector.internal-development.notifications.color.gray.option",
            defaultValue: "Gray",
            comment: "Color option label for gray notification tint"
        ), .gray)
    ]

    var body: some View {
        Section(String(
            localized: "inspector.internal-development.notifications.section.title",
            defaultValue: "Notifications",
            comment: "Section title for internal development notifications controls"
        )) {
            Toggle(String(
                localized: "inspector.internal-development.notifications.delay-5s.toggle",
                defaultValue: "Delay 5s",
                comment: "Toggle label to delay test notification by five seconds"
            ), isOn: $delay)
            Toggle(String(
                localized: "inspector.internal-development.notifications.sticky.toggle",
                defaultValue: "Sticky",
                comment: "Toggle label for sticky test notification behavior"
            ), isOn: $sticky)

            Picker(String(
                localized: "inspector.internal-development.notifications.icon-type.label",
                defaultValue: "Icon Type",
                comment: "Label for selecting notification icon type"
            ), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-type.symbol.option",
                        defaultValue: "Symbol",
                        comment: "Option label for symbol icon type"
                    ), selection: $selectedSymbol) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.symbol.random.option",
                            defaultValue: "Random",
                            comment: "Option label for random symbol selection"
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-type.emoji.option",
                        defaultValue: "Emoji",
                        comment: "Option label for emoji icon type"
                    ), selection: $selectedEmoji) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.emoji.random.option",
                            defaultValue: "Random",
                            comment: "Option label for random emoji selection"
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-type.text.option",
                        defaultValue: "Text",
                        comment: "Option label for text icon type"
                    ), selection: $selectedText) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.text.random.option",
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
                        localized: "inspector.internal-development.notifications.icon-type.image.option",
                        defaultValue: "Image",
                        comment: "Option label for image icon type"
                    ), selection: $selectedImage) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-type.image.random.option",
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
                        localized: "inspector.internal-development.notifications.icon-color.label",
                        defaultValue: "Icon Color",
                        comment: "Label for notification icon color setting"
                    ), selection: $selectedColor) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-color.random.option",
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
                localized: "inspector.internal-development.notifications.title.label",
                defaultValue: "Title",
                comment: "Label for notification title input"
            ), text: $notificationTitle)
            TextField(String(
                localized: "inspector.internal-development.notifications.description.label",
                defaultValue: "Description",
                comment: "Label for notification description input"
            ), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(
                localized: "inspector.internal-development.notifications.action-button.label",
                defaultValue: "Action Button",
                comment: "Label for notification action button text input"
            ), text: $actionButtonText)

            Button(String(
                localized: "inspector.internal-development.notifications.add-notification.button",
                defaultValue: "Add Notification",
                comment: "Button title to enqueue a test notification"
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
