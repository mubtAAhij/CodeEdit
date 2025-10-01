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
    @State private var actionButtonText: String = String(localized: "internal_dev.notifications.view", comment: "Default action button text for notifications")
    @State private var notificationTitle: String = String(localized: "internal_dev.notifications.test_notification", comment: "Default title for test notifications")
    @State private var notificationDescription: String = String(localized: "internal_dev.notifications.test_description", comment: "Default description for test notifications")

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
        (String(localized: "colors.red", comment: "Red color name"), .red), (String(localized: "colors.orange", comment: "Orange color name"), .orange), (String(localized: "colors.yellow", comment: "Yellow color name"), .yellow),
        (String(localized: "colors.green", comment: "Green color name"), .green), (String(localized: "colors.mint", comment: "Mint color name"), .mint), (String(localized: "colors.cyan", comment: "Cyan color name"), .cyan),
        (String(localized: "colors.teal", comment: "Teal color name"), .teal), (String(localized: "colors.blue", comment: "Blue color name"), .blue), (String(localized: "colors.indigo", comment: "Indigo color name"), .indigo),
        (String(localized: "colors.purple", comment: "Purple color name"), .purple), (String(localized: "inspector.notifications.color.pink", comment: "Pink color option"), .pink), (String(localized: "colors.gray", comment: "Gray color name"), .gray)
    ]

    var body: some View {
        Section(String(localized: "inspector.notifications.section_title", comment: "Notifications section title")) {
            Toggle(String(localized: "inspector.notifications.delay_toggle", comment: "Toggle for 5 second delay"), isOn: $delay)
            Toggle(String(localized: "inspector.notifications.sticky_toggle", comment: "Toggle for sticky notifications"), isOn: $sticky)

            Picker(String(localized: "inspector.notifications.icon_type_picker", comment: "Icon type picker"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker("Symbol", selection: $selectedSymbol) {
                        Label(String(localized: "inspector.notifications.random_option", comment: "Random selection option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker("Emoji", selection: $selectedEmoji) {
                        Label(String(localized: "inspector.notifications.random_option", comment: "Random selection option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker("Text", selection: $selectedText) {
                        Label(String(localized: "inspector.notifications.random_option", comment: "Random selection option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker("Image", selection: $selectedImage) {
                        Label(String(localized: "inspector.notifications.random_option", comment: "Random selection option"), systemImage: "dice").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "inspector.notifications.icon_color_picker", comment: "Icon color picker"), selection: $selectedColor) {
                        Label(String(localized: "inspector.notifications.random_option", comment: "Random selection option"), systemImage: "dice").tag(nil as Color?)
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

            TextField(String(localized: "inspector.notifications.title_field", comment: "Title text field"), text: $notificationTitle)
            TextField(String(localized: "inspector.notifications.description_field", comment: "Description text field"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "inspector.notifications.action_button_field", comment: "Action button text field"), text: $actionButtonText)

            Button(String(localized: "inspector.notifications.add_button", comment: "Add notification button")) {
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
