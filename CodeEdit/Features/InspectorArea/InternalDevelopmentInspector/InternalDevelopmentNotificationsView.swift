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
        localized: "internal-dev-notifications.action-button-default",
        defaultValue: "View",
        comment: "Default text for notification action button"
    )
    @State private var notificationTitle: String = String(
        localized: "internal-dev-notifications.title-default",
        defaultValue: "Test Notification",
        comment: "Default title for test notification"
    )
    @State private var notificationDescription: String = String(
        localized: "internal-dev-notifications.description-default",
        defaultValue: "This is a test notification.",
        comment: "Default description for test notification"
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
        (String(localized: "internal-dev-notifications.color.red", defaultValue: "Red", comment: "Red color option"), .red),
        (String(localized: "internal-dev-notifications.color.orange", defaultValue: "Orange", comment: "Orange color option"), .orange),
        (String(localized: "internal-dev-notifications.color.yellow", defaultValue: "Yellow", comment: "Yellow color option"), .yellow),
        (String(localized: "internal-dev-notifications.color.green", defaultValue: "Green", comment: "Green color option"), .green),
        (String(localized: "internal-dev-notifications.color.mint", defaultValue: "Mint", comment: "Mint color option"), .mint),
        (String(localized: "internal-dev-notifications.color.cyan", defaultValue: "Cyan", comment: "Cyan color option"), .cyan),
        (String(localized: "internal-dev-notifications.color.teal", defaultValue: "Teal", comment: "Teal color option"), .teal),
        (String(localized: "internal-dev-notifications.color.blue", defaultValue: "Blue", comment: "Blue color option"), .blue),
        (String(localized: "internal-dev-notifications.color.indigo", defaultValue: "Indigo", comment: "Indigo color option"), .indigo),
        (String(localized: "internal-dev-notifications.color.purple", defaultValue: "Purple", comment: "Purple color option"), .purple),
        (String(localized: "internal-dev-notifications.color.pink", defaultValue: "Pink", comment: "Pink color option"), .pink),
        (String(localized: "internal-dev-notifications.color.gray", defaultValue: "Gray", comment: "Gray color option"), .gray)
    ]

    var body: some View {
        Section(String(
            localized: "internal-dev-notifications.section-title",
            defaultValue: "Notifications",
            comment: "Section title for notifications testing"
        )) {
            Toggle(
                String(
                    localized: "internal-dev-notifications.delay-5s",
                    defaultValue: "Delay 5s",
                    comment: "Toggle to delay notification by 5 seconds"
                ),
                isOn: $delay
            )
            Toggle(
                String(
                    localized: "internal-dev-notifications.sticky",
                    defaultValue: "Sticky",
                    comment: "Toggle to make notification sticky"
                ),
                isOn: $sticky
            )

            Picker(
                String(
                    localized: "internal-dev-notifications.icon-type",
                    defaultValue: "Icon Type",
                    comment: "Picker label for notification icon type"
                ),
                selection: $selectedIconType
            ) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker("Symbol", selection: $selectedSymbol) {
                        Label(
                            String(
                                localized: "internal-dev-notifications.random",
                                defaultValue: "Random",
                                comment: "Option to select random icon"
                            ),
                            systemImage: "dice"
                        ).tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker("Emoji", selection: $selectedEmoji) {
                        Label(
                            String(
                                localized: "internal-dev-notifications.random",
                                defaultValue: "Random",
                                comment: "Option to select random icon"
                            ),
                            systemImage: "dice"
                        ).tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker("Text", selection: $selectedText) {
                        Label(
                            String(
                                localized: "internal-dev-notifications.random",
                                defaultValue: "Random",
                                comment: "Option to select random icon"
                            ),
                            systemImage: "dice"
                        ).tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker("Image", selection: $selectedImage) {
                        Label(
                            String(
                                localized: "internal-dev-notifications.random",
                                defaultValue: "Random",
                                comment: "Option to select random icon"
                            ),
                            systemImage: "dice"
                        ).tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(
                        String(
                            localized: "internal-dev-notifications.icon-color",
                            defaultValue: "Icon Color",
                            comment: "Picker label for icon color selection"
                        ),
                        selection: $selectedColor
                    ) {
                        Label(
                            String(
                                localized: "internal-dev-notifications.random",
                                defaultValue: "Random",
                                comment: "Option to select random icon"
                            ),
                            systemImage: "dice"
                        ).tag(nil as Color?)
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

            TextField(
                String(
                    localized: "internal-dev-notifications.title-label",
                    defaultValue: "Title",
                    comment: "Text field label for notification title"
                ),
                text: $notificationTitle
            )
            TextField(
                String(
                    localized: "internal-dev-notifications.description-label",
                    defaultValue: "Description",
                    comment: "Text field label for notification description"
                ),
                text: $notificationDescription,
                axis: .vertical
            )
                .lineLimit(1...5)
            TextField(
                String(
                    localized: "internal-dev-notifications.action-button-label",
                    defaultValue: "Action Button",
                    comment: "Text field label for notification action button text"
                ),
                text: $actionButtonText
            )

            Button(String(
                localized: "internal-dev-notifications.add-notification",
                defaultValue: "Add Notification",
                comment: "Button to add test notification"
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
