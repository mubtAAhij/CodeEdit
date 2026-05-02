//
//  InternalDevelopmentNotificationsView.swift
//  CodeEdit
//
//  Created by Austin Condiff on 2/19/24.
//

import SwiftUI

struct InternalDevelopmentNotificationsView: View {
    enum IconType: String, CaseIterable {
        case symbol = "symbol"
        case image = "image"
        case text = "text"
        case emoji = "emoji"

        var displayName: String {
            switch self {
            case .symbol:
                return String(localized: "internal-dev.notification.icon-type.symbol", defaultValue: "Symbol", comment: "Icon type for symbol")
            case .image:
                return String(localized: "internal-dev.notification.icon-type.image", defaultValue: "Image", comment: "Icon type for image")
            case .text:
                return String(localized: "internal-dev.notification.icon-type.text", defaultValue: "Text", comment: "Icon type for text")
            case .emoji:
                return String(localized: "internal-dev.notification.icon-type.emoji", defaultValue: "Emoji", comment: "Icon type for emoji")
            }
        }
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "internal-dev.notification.default-action", defaultValue: "View", comment: "Default action button text")
    @State private var notificationTitle: String = String(localized: "internal-dev.notification.default-title", defaultValue: "Test Notification", comment: "Default notification title")
    @State private var notificationDescription: String = String(localized: "internal-dev.notification.default-description", defaultValue: "This is a test notification.", comment: "Default notification description")

    // Icon selection states
    @State private var selectedSymbol: String?
    @State private var selectedEmoji: String?
    @State private var selectedText: String?
    @State private var selectedImage: String?
    @State private var selectedColor: Color?

    private let availableSymbols = [
        String(localized: "internal-dev.notification.symbol.bell-fill", defaultValue: "bell.fill", comment: "SF Symbol name for bell fill"),
        String(localized: "internal-dev.notification.symbol.bell-badge-fill", defaultValue: "bell.badge.fill", comment: "SF Symbol name for bell badge fill"),
        String(localized: "internal-dev.notification.symbol.exclamationmark-triangle-fill", defaultValue: "exclamationmark.triangle.fill", comment: "SF Symbol name for exclamationmark triangle fill"),
        String(localized: "internal-dev.notification.symbol.info-circle-fill", defaultValue: "info.circle.fill", comment: "SF Symbol name for info circle fill"),
        String(localized: "internal-dev.notification.symbol.checkmark-seal-fill", defaultValue: "checkmark.seal.fill", comment: "SF Symbol name for checkmark seal fill"),
        String(localized: "internal-dev.notification.symbol.xmark-octagon-fill", defaultValue: "xmark.octagon.fill", comment: "SF Symbol name for xmark octagon fill"),
        String(localized: "internal-dev.notification.symbol.bubble-left-fill", defaultValue: "bubble.left.fill", comment: "SF Symbol name for bubble left fill"),
        String(localized: "internal-dev.notification.symbol.envelope-fill", defaultValue: "envelope.fill", comment: "SF Symbol name for envelope fill"),
        String(localized: "internal-dev.notification.symbol.phone-fill", defaultValue: "phone.fill", comment: "SF Symbol name for phone fill"),
        String(localized: "internal-dev.notification.symbol.megaphone-fill", defaultValue: "megaphone.fill", comment: "SF Symbol name for megaphone fill"),
        String(localized: "internal-dev.notification.symbol.clock-fill", defaultValue: "clock.fill", comment: "SF Symbol name for clock fill"),
        String(localized: "internal-dev.notification.symbol.calendar", defaultValue: "calendar", comment: "SF Symbol name for calendar"),
        String(localized: "internal-dev.notification.symbol.flag-fill", defaultValue: "flag.fill", comment: "SF Symbol name for flag fill"),
        String(localized: "internal-dev.notification.symbol.bookmark-fill", defaultValue: "bookmark.fill", comment: "SF Symbol name for bookmark fill"),
        String(localized: "internal-dev.notification.symbol.bolt-fill", defaultValue: "bolt.fill", comment: "SF Symbol name for bolt fill"),
        String(localized: "internal-dev.notification.symbol.shield-lefthalf-fill", defaultValue: "shield.lefthalf.fill", comment: "SF Symbol name for shield lefthalf fill"),
        String(localized: "internal-dev.notification.symbol.gift-fill", defaultValue: "gift.fill", comment: "SF Symbol name for gift fill"),
        String(localized: "internal-dev.notification.symbol.heart-fill", defaultValue: "heart.fill", comment: "SF Symbol name for heart fill"),
        String(localized: "internal-dev.notification.symbol.star-fill", defaultValue: "star.fill", comment: "SF Symbol name for star fill"),
        String(localized: "internal-dev.notification.symbol.curlybraces", defaultValue: "curlybraces", comment: "SF Symbol name for curlybraces")
    ]

    private let availableEmojis = [
        String(localized: "internal-dev.notification.emoji.bell", defaultValue: "🔔", comment: "Emoji bell"),
        String(localized: "internal-dev.notification.emoji.siren", defaultValue: "🚨", comment: "Emoji siren"),
        String(localized: "internal-dev.notification.emoji.warning", defaultValue: "⚠️", comment: "Emoji warning"),
        String(localized: "internal-dev.notification.emoji.wave", defaultValue: "👋", comment: "Emoji wave"),
        String(localized: "internal-dev.notification.emoji.heart-eyes", defaultValue: "😍", comment: "Emoji heart eyes"),
        String(localized: "internal-dev.notification.emoji.cool", defaultValue: "😎", comment: "Emoji cool"),
        String(localized: "internal-dev.notification.emoji.kiss", defaultValue: "😘", comment: "Emoji kiss"),
        String(localized: "internal-dev.notification.emoji.tongue-wink", defaultValue: "😜", comment: "Emoji tongue wink"),
        String(localized: "internal-dev.notification.emoji.tongue", defaultValue: "😝", comment: "Emoji tongue"),
        String(localized: "internal-dev.notification.emoji.grin", defaultValue: "😀", comment: "Emoji grin"),
        String(localized: "internal-dev.notification.emoji.grin-teeth", defaultValue: "😁", comment: "Emoji grin teeth"),
        String(localized: "internal-dev.notification.emoji.joy", defaultValue: "😂", comment: "Emoji joy"),
        String(localized: "internal-dev.notification.emoji.laughing", defaultValue: "🤣", comment: "Emoji laughing"),
        String(localized: "internal-dev.notification.emoji.smiley", defaultValue: "😃", comment: "Emoji smiley"),
        String(localized: "internal-dev.notification.emoji.smile", defaultValue: "😄", comment: "Emoji smile"),
        String(localized: "internal-dev.notification.emoji.sweat-smile", defaultValue: "😅", comment: "Emoji sweat smile"),
        String(localized: "internal-dev.notification.emoji.laughing-squint", defaultValue: "😆", comment: "Emoji laughing squint"),
        String(localized: "internal-dev.notification.emoji.innocent", defaultValue: "😇", comment: "Emoji innocent"),
        String(localized: "internal-dev.notification.emoji.wink", defaultValue: "😉", comment: "Emoji wink"),
        String(localized: "internal-dev.notification.emoji.blush", defaultValue: "😊", comment: "Emoji blush"),
        String(localized: "internal-dev.notification.emoji.yum", defaultValue: "😋", comment: "Emoji yum"),
        String(localized: "internal-dev.notification.emoji.relieved", defaultValue: "😌", comment: "Emoji relieved")
    ]

    private let availableImages = [
        String(localized: "internal-dev.notification.image.github", defaultValue: "GitHubIcon", comment: "Image name for GitHub icon"),
        String(localized: "internal-dev.notification.image.bitbucket", defaultValue: "BitBucketIcon", comment: "Image name for BitBucket icon"),
        String(localized: "internal-dev.notification.image.gitlab", defaultValue: "GitLabIcon", comment: "Image name for GitLab icon")
    ]

    private let availableColors: [(String, Color)] = [
        (String(localized: "internal-dev.notification.color.red", defaultValue: "Red", comment: "Color name for red"), .red),
        (String(localized: "internal-dev.notification.color.orange", defaultValue: "Orange", comment: "Color name for orange"), .orange),
        (String(localized: "internal-dev.notification.color.yellow", defaultValue: "Yellow", comment: "Color name for yellow"), .yellow),
        (String(localized: "internal-dev.notification.color.green", defaultValue: "Green", comment: "Color name for green"), .green),
        (String(localized: "internal-dev.notification.color.mint", defaultValue: "Mint", comment: "Color name for mint"), .mint),
        (String(localized: "internal-dev.notification.color.cyan", defaultValue: "Cyan", comment: "Color name for cyan"), .cyan),
        (String(localized: "internal-dev.notification.color.teal", defaultValue: "Teal", comment: "Color name for teal"), .teal),
        (String(localized: "internal-dev.notification.color.blue", defaultValue: "Blue", comment: "Color name for blue"), .blue),
        (String(localized: "internal-dev.notification.color.indigo", defaultValue: "Indigo", comment: "Color name for indigo"), .indigo),
        (String(localized: "internal-dev.notification.color.purple", defaultValue: "Purple", comment: "Color name for purple"), .purple),
        (String(localized: "internal-dev.notification.color.pink", defaultValue: "Pink", comment: "Color name for pink"), .pink),
        (String(localized: "internal-dev.notification.color.gray", defaultValue: "Gray", comment: "Color name for gray"), .gray)
    ]

    var body: some View {
        Section(String(localized: "internal-dev.notification.section-title", defaultValue: "Notifications", comment: "Section title for notifications")) {
            Toggle(String(localized: "internal-dev.notification.delay-5s", defaultValue: "Delay 5s", comment: "Toggle label for 5 second delay"), isOn: $delay)
            Toggle(String(localized: "internal-dev.notification.sticky", defaultValue: "Sticky", comment: "Toggle label for sticky notifications"), isOn: $sticky)

            Picker(String(localized: "internal-dev.notification.icon-type-label", defaultValue: "Icon Type", comment: "Label for icon type picker"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "internal-dev.notification.picker.symbol", defaultValue: "Symbol", comment: "Picker label for symbol selection"), selection: $selectedSymbol) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Label for random selection"), systemImage: String(localized: "internal-dev.notification.dice-icon", defaultValue: "dice", comment: "SF Symbol name for dice")).tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "internal-dev.notification.picker.emoji", defaultValue: "Emoji", comment: "Picker label for emoji selection"), selection: $selectedEmoji) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Label for random selection"), systemImage: String(localized: "internal-dev.notification.dice-icon", defaultValue: "dice", comment: "SF Symbol name for dice")).tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "internal-dev.notification.picker.text", defaultValue: "Text", comment: "Picker label for text selection"), selection: $selectedText) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Label for random selection"), systemImage: String(localized: "internal-dev.notification.dice-icon", defaultValue: "dice", comment: "SF Symbol name for dice")).tag(nil as String?)
                        Divider()
                        ForEach(String(localized: "internal-dev.notification.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet string for letter selection").map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "internal-dev.notification.picker.image", defaultValue: "Image", comment: "Picker label for image selection"), selection: $selectedImage) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Label for random selection"), systemImage: String(localized: "internal-dev.notification.dice-icon", defaultValue: "dice", comment: "SF Symbol name for dice")).tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "internal-dev.notification.icon-color", defaultValue: "Icon Color", comment: "Label for icon color picker"), selection: $selectedColor) {
                        Label(String(localized: "internal-dev.notification.random", defaultValue: "Random", comment: "Label for random selection"), systemImage: String(localized: "internal-dev.notification.dice-icon", defaultValue: "dice", comment: "SF Symbol name for dice")).tag(nil as Color?)
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

            TextField(String(localized: "internal-dev.notification.title-field", defaultValue: "Title", comment: "Label for title text field"), text: $notificationTitle)
            TextField(String(localized: "internal-dev.notification.description-field", defaultValue: "Description", comment: "Label for description text field"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "internal-dev.notification.action-button-field", defaultValue: "Action Button", comment: "Label for action button text field"), text: $actionButtonText)

            Button(String(localized: "internal-dev.notification.add-button", defaultValue: "Add Notification", comment: "Button label to add notification")) {
                let action = {
                    switch selectedIconType {
                    case .symbol:
                        let iconSymbol = selectedSymbol ?? availableSymbols.randomElement() ?? String(localized: "internal-dev.notification.default-symbol", defaultValue: "bell.fill", comment: "Default SF Symbol for notification")
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
                        let imageName = selectedImage ?? availableImages.randomElement() ?? String(localized: "internal-dev.notification.default-image", defaultValue: "GitHubIcon", comment: "Default image name for notification")

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
                        let emoji = selectedEmoji ?? availableEmojis.randomElement() ?? String(localized: "internal-dev.notification.default-emoji", defaultValue: "🔔", comment: "Default emoji for notification")
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
        let letters = String(localized: "internal-dev.notification.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet string for letter selection").map { String($0) }
        return letters.randomElement() ?? String(localized: "internal-dev.notification.default-letter", defaultValue: "A", comment: "Default letter for notification")
    }
}
