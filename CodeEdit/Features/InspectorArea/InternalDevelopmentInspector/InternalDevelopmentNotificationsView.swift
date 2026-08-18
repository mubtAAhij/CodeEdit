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
        localized: "inspector.internal-development.notifications.preview.view",
        defaultValue: "View",
        comment: "Label for view preview target of test notification."
    )
    @State private var notificationTitle: String = String(
        localized: "inspector.internal-development.notifications.test-notification.title",
        defaultValue: "Test Notification",
        comment: "Title text for generated test notification."
    )
    @State private var notificationDescription: String = String(
        localized: "inspector.internal-development.notifications.test-notification.message",
        defaultValue: "This is a test notification.",
        comment: "Body text for generated test notification."
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
            comment: "Color option label for red notification color."
        ), .red), (String(
            localized: "inspector.internal-development.notifications.color.orange",
            defaultValue: "Orange",
            comment: "Color option label for orange notification color."
        ), .orange), (String(
            localized: "inspector.internal-development.notifications.color.yellow",
            defaultValue: "Yellow",
            comment: "Color option label for yellow notification color."
        ), .yellow),
        (String(
            localized: "inspector.internal-development.notifications.color.green",
            defaultValue: "Green",
            comment: "Color option label for green notification color."
        ), .green), (String(
            localized: "inspector.internal-development.notifications.color.mint",
            defaultValue: "Mint",
            comment: "Color option label for mint notification color."
        ), .mint), (String(
            localized: "inspector.internal-development.notifications.color.cyan",
            defaultValue: "Cyan",
            comment: "Color option label for cyan notification color."
        ), .cyan),
        (String(
            localized: "inspector.internal-development.notifications.color.teal",
            defaultValue: "Teal",
            comment: "Color option label for teal notification color."
        ), .teal), (String(
            localized: "inspector.internal-development.notifications.color.blue",
            defaultValue: "Blue",
            comment: "Color option label for blue notification color."
        ), .blue), (String(
            localized: "inspector.internal-development.notifications.color.indigo",
            defaultValue: "Indigo",
            comment: "Color option label for indigo notification color."
        ), .indigo),
        (String(
            localized: "inspector.internal-development.notifications.color.purple",
            defaultValue: "Purple",
            comment: "Color option label for purple notification color."
        ), .purple), (String(
            localized: "inspector.internal-development.notifications.color.pink",
            defaultValue: "Pink",
            comment: "Color option label for pink notification color."
        ), .pink), (String(
            localized: "inspector.internal-development.notifications.color.gray",
            defaultValue: "Gray",
            comment: "Color option label for gray notification color."
        ), .gray)
    ]

    var body: some View {
        Section(String(
            localized: "inspector.internal-development.notifications.title",
            defaultValue: "Notifications",
            comment: "Section title for internal development notifications inspector."
        )) {
            Toggle(String(
                localized: "inspector.internal-development.notifications.option.delay-5s",
                defaultValue: "Delay 5s",
                comment: "Option label to delay notification dismissal by five seconds."
            ), isOn: $delay)
            Toggle(String(
                localized: "inspector.internal-development.notifications.option.sticky",
                defaultValue: "Sticky",
                comment: "Option label for sticky notification behavior."
            ), isOn: $sticky)

            Picker(String(
                localized: "inspector.internal-development.notifications.icon-type.title",
                defaultValue: "Icon Type",
                comment: "Section title for selecting notification icon type."
            ), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-source.symbol",
                        defaultValue: "Symbol",
                        comment: "Label for symbol icon source input."
                    ), selection: $selectedSymbol) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-source.random",
                            defaultValue: "Random",
                            comment: "Button label to pick a random icon source value."
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-source.emoji",
                        defaultValue: "Emoji",
                        comment: "Label for emoji icon source input."
                    ), selection: $selectedEmoji) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-source.random",
                            defaultValue: "Random",
                            comment: "Button label to pick a random emoji value."
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-source.text",
                        defaultValue: "Text",
                        comment: "Label for text icon source input."
                    ), selection: $selectedText) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-source.random",
                            defaultValue: "Random",
                            comment: "Button label to pick a random text icon value."
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-source.image",
                        defaultValue: "Image",
                        comment: "Label for image icon source input."
                    ), selection: $selectedImage) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-source.random",
                            defaultValue: "Random",
                            comment: "Button label to pick a random image icon value."
                        ), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(
                        localized: "inspector.internal-development.notifications.icon-color.title",
                        defaultValue: "Icon Color",
                        comment: "Section title for selecting notification icon color."
                    ), selection: $selectedColor) {
                        Label(String(
                            localized: "inspector.internal-development.notifications.icon-color.random",
                            defaultValue: "Random",
                            comment: "Button label to pick a random icon color."
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
                localized: "inspector.internal-development.notifications.fields.title",
                defaultValue: "Title",
                comment: "Label for notification title input field."
            ), text: $notificationTitle)
            TextField(String(
                localized: "inspector.internal-development.notifications.fields.description",
                defaultValue: "Description",
                comment: "Label for notification description input field."
            ), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(
                localized: "inspector.internal-development.notifications.fields.action-button",
                defaultValue: "Action Button",
                comment: "Label for notification action button text field."
            ), text: $actionButtonText)

            Button(String(
                localized: "inspector.internal-development.notifications.add-notification",
                defaultValue: "Add Notification",
                comment: "Button title to trigger creation of a test notification."
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
                            localized: "inspector.internal-development.notifications.icon-source.github-icon",
                            defaultValue: "GitHubIcon",
                            comment: "Specific icon source value label used in notification test data."
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
