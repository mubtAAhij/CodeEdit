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
    @State private var actionButtonText: String = String(localized: "dev.notifications.view", comment: "Action button text")
    @State private var notificationTitle: String = String(localized: "dev.notifications.test_title", comment: "Notification title")
    @State private var notificationDescription: String = String(localized: "dev.notifications.test_description", comment: "Notification description")

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
        (String(localized: "colors.red", comment: "Red color"), .red), (String(localized: "colors.orange", comment: "Orange color"), .orange), (String(localized: "colors.yellow", comment: "Yellow color"), .yellow),
        (String(localized: "colors.green", comment: "Green color"), .green), (String(localized: "colors.mint", comment: "Mint color"), .mint), (String(localized: "colors.cyan", comment: "Cyan color"), .cyan),
        (String(localized: "colors.teal", comment: "Teal color"), .teal), (String(localized: "colors.blue", comment: "Blue color"), .blue), (String(localized: "colors.indigo", comment: "Indigo color"), .indigo),
        (String(localized: "colors.purple", comment: "Purple color"), .purple), (String(localized: "colors.pink", comment: "Pink color"), .pink), (String(localized: "colors.gray", comment: "Gray color"), .gray)
    ]

    var body: some View {
        Section("dev.notifications.section", comment: "Notifications section") {
            Toggle("dev.notifications.delay", comment: "Delay toggle", isOn: $delay)
            Toggle("dev.notifications.sticky", comment: "Sticky toggle", isOn: $sticky)

            Picker("dev.notifications.icon_type", comment: "Icon type picker", selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker("Symbol", selection: $selectedSymbol) {
                        Label("dev.notifications.random", systemImage: "dice", comment: "Random option").tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker("dev.notifications.emoji", comment: "Emoji picker label", selection: $selectedEmoji) {
                        Label("dev.notifications.random_emoji", systemImage: "dice", comment: "Random emoji option").tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker("dev.notifications.text", comment: "Text picker label", selection: $selectedText) {
                        Label("dev.notifications.random_text", systemImage: "dice", comment: "Random text option").tag(nil as String?)
                        Divider()
                        ForEach("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker("dev.notifications.image", comment: "Image picker label", selection: $selectedImage) {
                        Label("dev.notifications.random_image", systemImage: "dice", comment: "Random image option").tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker("dev.notifications.icon_color", comment: "Icon color picker", selection: $selectedColor) {
                        Label("dev.notifications.random_color", systemImage: "dice", comment: "Random color option").tag(nil as Color?)
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

            TextField("dev.notifications.title", text: $notificationTitle, comment: "Title field")
            TextField("dev.notifications.description", text: $notificationDescription, axis: .vertical, comment: "Description field")
                .lineLimit(1...5)
            TextField("dev.notifications.action_button", text: $actionButtonText, comment: "Action button field")

            Button("dev.notifications.add", comment: "Add notification button") {
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
