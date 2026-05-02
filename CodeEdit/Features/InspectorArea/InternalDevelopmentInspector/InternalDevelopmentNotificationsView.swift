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
                return String(localized: "internal.development.notifications.icon.type.symbol", defaultValue: "Symbol", comment: "Symbol icon type for notifications")
            case .image:
                return String(localized: "internal.development.notifications.icon.type.image", defaultValue: "Image", comment: "Image icon type for notifications")
            case .text:
                return String(localized: "internal.development.notifications.icon.type.text", defaultValue: "Text", comment: "Text icon type for notifications")
            case .emoji:
                return String(localized: "internal.development.notifications.icon.type.emoji", defaultValue: "Emoji", comment: "Emoji icon type for notifications")
            }
        }
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "internal.development.notifications.action.button.default", defaultValue: "View", comment: "Default action button text for test notification")
    @State private var notificationTitle: String = String(localized: "internal.development.notifications.title.default", defaultValue: "Test Notification", comment: "Default title for test notification")
    @State private var notificationDescription: String = String(localized: "internal.development.notifications.description.default", defaultValue: "This is a test notification.", comment: "Default description for test notification")

    // Icon selection states
    @State private var selectedSymbol: String?
    @State private var selectedEmoji: String?
    @State private var selectedText: String?
    @State private var selectedImage: String?
    @State private var selectedColor: Color?

    private let availableSymbols = [
        String(localized: "internal.development.notifications.symbol.bell.fill", defaultValue: "bell.fill", comment: "SF Symbol name for bell fill icon"),
        String(localized: "internal.development.notifications.symbol.bell.badge.fill", defaultValue: "bell.badge.fill", comment: "SF Symbol name for bell badge fill icon"),
        String(localized: "internal.development.notifications.symbol.exclamationmark.triangle.fill", defaultValue: "exclamationmark.triangle.fill", comment: "SF Symbol name for exclamation mark triangle fill icon"),
        String(localized: "internal.development.notifications.symbol.info.circle.fill", defaultValue: "info.circle.fill", comment: "SF Symbol name for info circle fill icon"),
        String(localized: "internal.development.notifications.symbol.checkmark.seal.fill", defaultValue: "checkmark.seal.fill", comment: "SF Symbol name for checkmark seal fill icon"),
        String(localized: "internal.development.notifications.symbol.xmark.octagon.fill", defaultValue: "xmark.octagon.fill", comment: "SF Symbol name for xmark octagon fill icon"),
        String(localized: "internal.development.notifications.symbol.bubble.left.fill", defaultValue: "bubble.left.fill", comment: "SF Symbol name for bubble left fill icon"),
        String(localized: "internal.development.notifications.symbol.envelope.fill", defaultValue: "envelope.fill", comment: "SF Symbol name for envelope fill icon"),
        String(localized: "internal.development.notifications.symbol.phone.fill", defaultValue: "phone.fill", comment: "SF Symbol name for phone fill icon"),
        String(localized: "internal.development.notifications.symbol.megaphone.fill", defaultValue: "megaphone.fill", comment: "SF Symbol name for megaphone fill icon"),
        String(localized: "internal.development.notifications.symbol.clock.fill", defaultValue: "clock.fill", comment: "SF Symbol name for clock fill icon"),
        String(localized: "internal.development.notifications.symbol.calendar", defaultValue: "calendar", comment: "SF Symbol name for calendar icon"),
        String(localized: "internal.development.notifications.symbol.flag.fill", defaultValue: "flag.fill", comment: "SF Symbol name for flag fill icon"),
        String(localized: "internal.development.notifications.symbol.bookmark.fill", defaultValue: "bookmark.fill", comment: "SF Symbol name for bookmark fill icon"),
        String(localized: "internal.development.notifications.symbol.bolt.fill", defaultValue: "bolt.fill", comment: "SF Symbol name for bolt fill icon"),
        String(localized: "internal.development.notifications.symbol.shield.lefthalf.fill", defaultValue: "shield.lefthalf.fill", comment: "SF Symbol name for shield lefthalf fill icon"),
        String(localized: "internal.development.notifications.symbol.gift.fill", defaultValue: "gift.fill", comment: "SF Symbol name for gift fill icon"),
        String(localized: "internal.development.notifications.symbol.heart.fill", defaultValue: "heart.fill", comment: "SF Symbol name for heart fill icon"),
        String(localized: "internal.development.notifications.symbol.star.fill", defaultValue: "star.fill", comment: "SF Symbol name for star fill icon"),
        String(localized: "internal.development.notifications.symbol.curlybraces", defaultValue: "curlybraces", comment: "SF Symbol name for curlybraces icon")
    ]

    private let availableEmojis = [
        String(localized: "internal.development.notifications.emoji.bell", defaultValue: "🔔", comment: "Bell emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.siren", defaultValue: "🚨", comment: "Siren emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.warning", defaultValue: "⚠️", comment: "Warning emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.wave", defaultValue: "👋", comment: "Wave emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.heart.eyes", defaultValue: "😍", comment: "Heart eyes emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.sunglasses", defaultValue: "😎", comment: "Sunglasses emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.kiss", defaultValue: "😘", comment: "Kiss emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.wink.tongue", defaultValue: "😜", comment: "Wink tongue emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.squint.tongue", defaultValue: "😝", comment: "Squint tongue emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.grin", defaultValue: "😀", comment: "Grin emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.beam", defaultValue: "😁", comment: "Beam emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.laugh.tears", defaultValue: "😂", comment: "Laugh tears emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.rofl", defaultValue: "🤣", comment: "ROFL emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.smile", defaultValue: "😃", comment: "Smile emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.big.smile", defaultValue: "😄", comment: "Big smile emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.sweat.smile", defaultValue: "😅", comment: "Sweat smile emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.squint.laugh", defaultValue: "😆", comment: "Squint laugh emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.halo", defaultValue: "😇", comment: "Halo emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.wink", defaultValue: "😉", comment: "Wink emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.blush", defaultValue: "😊", comment: "Blush emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.yum", defaultValue: "😋", comment: "Yum emoji for notifications"),
        String(localized: "internal.development.notifications.emoji.relieved", defaultValue: "😌", comment: "Relieved emoji for notifications")
    ]

    private let availableImages = [
        String(localized: "internal.development.notifications.image.github", defaultValue: "GitHubIcon", comment: "GitHub icon asset name"),
        String(localized: "internal.development.notifications.image.bitbucket", defaultValue: "BitBucketIcon", comment: "BitBucket icon asset name"),
        String(localized: "internal.development.notifications.image.gitlab", defaultValue: "GitLabIcon", comment: "GitLab icon asset name")
    ]

    private let availableColors: [(String, Color)] = [
        (String(localized: "internal.development.notifications.color.red", defaultValue: "Red", comment: "Red color name"), .red),
        (String(localized: "internal.development.notifications.color.orange", defaultValue: "Orange", comment: "Orange color name"), .orange),
        (String(localized: "internal.development.notifications.color.yellow", defaultValue: "Yellow", comment: "Yellow color name"), .yellow),
        (String(localized: "internal.development.notifications.color.green", defaultValue: "Green", comment: "Green color name"), .green),
        (String(localized: "internal.development.notifications.color.mint", defaultValue: "Mint", comment: "Mint color name"), .mint),
        (String(localized: "internal.development.notifications.color.cyan", defaultValue: "Cyan", comment: "Cyan color name"), .cyan),
        (String(localized: "internal.development.notifications.color.teal", defaultValue: "Teal", comment: "Teal color name"), .teal),
        (String(localized: "internal.development.notifications.color.blue", defaultValue: "Blue", comment: "Blue color name"), .blue),
        (String(localized: "internal.development.notifications.color.indigo", defaultValue: "Indigo", comment: "Indigo color name"), .indigo),
        (String(localized: "internal.development.notifications.color.purple", defaultValue: "Purple", comment: "Purple color name"), .purple),
        (String(localized: "internal.development.notifications.color.pink", defaultValue: "Pink", comment: "Pink color name"), .pink),
        (String(localized: "internal.development.notifications.color.gray", defaultValue: "Gray", comment: "Gray color name"), .gray)
    ]

    var body: some View {
        Section(String(localized: "internal.development.notifications.section.title", defaultValue: "Notifications", comment: "Title for notifications section")) {
            Toggle(String(localized: "internal.development.notifications.delay.toggle", defaultValue: "Delay 5s", comment: "Toggle for delaying notification by 5 seconds"), isOn: $delay)
            Toggle(String(localized: "internal.development.notifications.sticky.toggle", defaultValue: "Sticky", comment: "Toggle for sticky notification"), isOn: $sticky)

            Picker(String(localized: "internal.development.notifications.icon.type.picker", defaultValue: "Icon Type", comment: "Picker label for icon type"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "internal.development.notifications.symbol.picker", defaultValue: "Symbol", comment: "Picker label for symbol selection"), selection: $selectedSymbol) {
                        Label(String(localized: "internal.development.notifications.random.label", defaultValue: "Random", comment: "Label for random selection option"), systemImage: String(localized: "internal.development.notifications.dice.icon", defaultValue: "dice", comment: "SF Symbol name for dice icon")).tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "internal.development.notifications.emoji.picker", defaultValue: "Emoji", comment: "Picker label for emoji selection"), selection: $selectedEmoji) {
                        Label(String(localized: "internal.development.notifications.random.label", defaultValue: "Random", comment: "Label for random selection option"), systemImage: String(localized: "internal.development.notifications.dice.icon", defaultValue: "dice", comment: "SF Symbol name for dice icon")).tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "internal.development.notifications.text.picker", defaultValue: "Text", comment: "Picker label for text selection"), selection: $selectedText) {
                        Label(String(localized: "internal.development.notifications.random.label", defaultValue: "Random", comment: "Label for random selection option"), systemImage: String(localized: "internal.development.notifications.dice.icon", defaultValue: "dice", comment: "SF Symbol name for dice icon")).tag(nil as String?)
                        Divider()
                        ForEach(String(localized: "internal.development.notifications.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet for text icon selection").map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "internal.development.notifications.image.picker", defaultValue: "Image", comment: "Picker label for image selection"), selection: $selectedImage) {
                        Label(String(localized: "internal.development.notifications.random.label", defaultValue: "Random", comment: "Label for random selection option"), systemImage: String(localized: "internal.development.notifications.dice.icon", defaultValue: "dice", comment: "SF Symbol name for dice icon")).tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "internal.development.notifications.icon.color.picker", defaultValue: "Icon Color", comment: "Picker label for icon color"), selection: $selectedColor) {
                        Label(String(localized: "internal.development.notifications.random.label", defaultValue: "Random", comment: "Label for random selection option"), systemImage: String(localized: "internal.development.notifications.dice.icon", defaultValue: "dice", comment: "SF Symbol name for dice icon")).tag(nil as Color?)
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

            TextField(String(localized: "internal.development.notifications.title.field", defaultValue: "Title", comment: "Text field label for notification title"), text: $notificationTitle)
            TextField(String(localized: "internal.development.notifications.description.field", defaultValue: "Description", comment: "Text field label for notification description"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "internal.development.notifications.action.button.field", defaultValue: "Action Button", comment: "Text field label for action button text"), text: $actionButtonText)

            Button(String(localized: "internal.development.notifications.add.button", defaultValue: "Add Notification", comment: "Button to add a test notification")) {
                let action = {
                    switch selectedIconType {
                    case .symbol:
                        let iconSymbol = selectedSymbol ?? availableSymbols.randomElement() ?? String(localized: "internal.development.notifications.default.symbol", defaultValue: "bell.fill", comment: "Default SF Symbol for notification")
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
                        let imageName = selectedImage ?? availableImages.randomElement() ?? String(localized: "internal.development.notifications.default.image", defaultValue: "GitHubIcon", comment: "Default image asset for notification")

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
                        let emoji = selectedEmoji ?? availableEmojis.randomElement() ?? String(localized: "internal.development.notifications.default.emoji", defaultValue: "🔔", comment: "Default emoji for notification")
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
        let letters = String(localized: "internal.development.notifications.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet for text icon selection").map { String($0) }
        return letters.randomElement() ?? String(localized: "internal.development.notifications.default.letter", defaultValue: "A", comment: "Default letter for notification")
    }
}
