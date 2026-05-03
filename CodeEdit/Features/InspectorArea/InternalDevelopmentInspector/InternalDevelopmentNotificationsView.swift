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
                return String(localized: "internal_dev.notifications.icon_type.symbol", defaultValue: "Symbol", comment: "Symbol icon type option")
            case .image:
                return String(localized: "internal_dev.notifications.icon_type.image", defaultValue: "Image", comment: "Image icon type option")
            case .text:
                return String(localized: "internal_dev.notifications.icon_type.text", defaultValue: "Text", comment: "Text icon type option")
            case .emoji:
                return String(localized: "internal_dev.notifications.icon_type.emoji", defaultValue: "Emoji", comment: "Emoji icon type option")
            }
        }
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "internal_dev.notifications.default_action", defaultValue: "View", comment: "Default action button text")
    @State private var notificationTitle: String = String(localized: "internal_dev.notifications.default_title", defaultValue: "Test Notification", comment: "Default notification title")
    @State private var notificationDescription: String = String(localized: "internal_dev.notifications.default_description", defaultValue: "This is a test notification.", comment: "Default notification description")

    // Icon selection states
    @State private var selectedSymbol: String?
    @State private var selectedEmoji: String?
    @State private var selectedText: String?
    @State private var selectedImage: String?
    @State private var selectedColor: Color?

    private let availableSymbols = [
        String(localized: "internal_dev.notifications.symbol.bell_fill", defaultValue: "bell.fill", comment: "Bell fill symbol"),
        String(localized: "internal_dev.notifications.symbol.bell_badge_fill", defaultValue: "bell.badge.fill", comment: "Bell badge fill symbol"),
        String(localized: "internal_dev.notifications.symbol.exclamationmark_triangle_fill", defaultValue: "exclamationmark.triangle.fill", comment: "Exclamation mark triangle fill symbol"),
        String(localized: "internal_dev.notifications.symbol.info_circle_fill", defaultValue: "info.circle.fill", comment: "Info circle fill symbol"),
        String(localized: "internal_dev.notifications.symbol.checkmark_seal_fill", defaultValue: "checkmark.seal.fill", comment: "Checkmark seal fill symbol"),
        String(localized: "internal_dev.notifications.symbol.xmark_octagon_fill", defaultValue: "xmark.octagon.fill", comment: "X mark octagon fill symbol"),
        String(localized: "internal_dev.notifications.symbol.bubble_left_fill", defaultValue: "bubble.left.fill", comment: "Bubble left fill symbol"),
        String(localized: "internal_dev.notifications.symbol.envelope_fill", defaultValue: "envelope.fill", comment: "Envelope fill symbol"),
        String(localized: "internal_dev.notifications.symbol.phone_fill", defaultValue: "phone.fill", comment: "Phone fill symbol"),
        String(localized: "internal_dev.notifications.symbol.megaphone_fill", defaultValue: "megaphone.fill", comment: "Megaphone fill symbol"),
        String(localized: "internal_dev.notifications.symbol.clock_fill", defaultValue: "clock.fill", comment: "Clock fill symbol"),
        String(localized: "internal_dev.notifications.symbol.calendar", defaultValue: "calendar", comment: "Calendar symbol"),
        String(localized: "internal_dev.notifications.symbol.flag_fill", defaultValue: "flag.fill", comment: "Flag fill symbol"),
        String(localized: "internal_dev.notifications.symbol.bookmark_fill", defaultValue: "bookmark.fill", comment: "Bookmark fill symbol"),
        String(localized: "internal_dev.notifications.symbol.bolt_fill", defaultValue: "bolt.fill", comment: "Bolt fill symbol"),
        String(localized: "internal_dev.notifications.symbol.shield_lefthalf_fill", defaultValue: "shield.lefthalf.fill", comment: "Shield left half fill symbol"),
        String(localized: "internal_dev.notifications.symbol.gift_fill", defaultValue: "gift.fill", comment: "Gift fill symbol"),
        String(localized: "internal_dev.notifications.symbol.heart_fill", defaultValue: "heart.fill", comment: "Heart fill symbol"),
        String(localized: "internal_dev.notifications.symbol.star_fill", defaultValue: "star.fill", comment: "Star fill symbol"),
        String(localized: "internal_dev.notifications.symbol.curlybraces", defaultValue: "curlybraces", comment: "Curly braces symbol")
    ]

    private let availableEmojis = [
        String(localized: "internal_dev.notifications.emoji.bell", defaultValue: "🔔", comment: "Bell emoji"),
        String(localized: "internal_dev.notifications.emoji.siren", defaultValue: "🚨", comment: "Siren emoji"),
        String(localized: "internal_dev.notifications.emoji.warning", defaultValue: "⚠️", comment: "Warning emoji"),
        String(localized: "internal_dev.notifications.emoji.wave", defaultValue: "👋", comment: "Wave emoji"),
        String(localized: "internal_dev.notifications.emoji.heart_eyes", defaultValue: "😍", comment: "Heart eyes emoji"),
        String(localized: "internal_dev.notifications.emoji.cool", defaultValue: "😎", comment: "Cool emoji"),
        String(localized: "internal_dev.notifications.emoji.kiss", defaultValue: "😘", comment: "Kiss emoji"),
        String(localized: "internal_dev.notifications.emoji.wink_tongue", defaultValue: "😜", comment: "Wink tongue emoji"),
        String(localized: "internal_dev.notifications.emoji.tongue", defaultValue: "😝", comment: "Tongue emoji"),
        String(localized: "internal_dev.notifications.emoji.grinning", defaultValue: "😀", comment: "Grinning emoji"),
        String(localized: "internal_dev.notifications.emoji.grin", defaultValue: "😁", comment: "Grin emoji"),
        String(localized: "internal_dev.notifications.emoji.joy", defaultValue: "😂", comment: "Joy emoji"),
        String(localized: "internal_dev.notifications.emoji.rofl", defaultValue: "🤣", comment: "ROFL emoji"),
        String(localized: "internal_dev.notifications.emoji.smile", defaultValue: "😃", comment: "Smile emoji"),
        String(localized: "internal_dev.notifications.emoji.smile_open", defaultValue: "😄", comment: "Smile open emoji"),
        String(localized: "internal_dev.notifications.emoji.sweat_smile", defaultValue: "😅", comment: "Sweat smile emoji"),
        String(localized: "internal_dev.notifications.emoji.laughing", defaultValue: "😆", comment: "Laughing emoji"),
        String(localized: "internal_dev.notifications.emoji.innocent", defaultValue: "😇", comment: "Innocent emoji"),
        String(localized: "internal_dev.notifications.emoji.wink", defaultValue: "😉", comment: "Wink emoji"),
        String(localized: "internal_dev.notifications.emoji.blush", defaultValue: "😊", comment: "Blush emoji"),
        String(localized: "internal_dev.notifications.emoji.yum", defaultValue: "😋", comment: "Yum emoji"),
        String(localized: "internal_dev.notifications.emoji.relieved", defaultValue: "😌", comment: "Relieved emoji")
    ]

    private let availableImages = [
        String(localized: "internal_dev.notifications.image.github", defaultValue: "GitHubIcon", comment: "GitHub icon image name"),
        String(localized: "internal_dev.notifications.image.bitbucket", defaultValue: "BitBucketIcon", comment: "BitBucket icon image name"),
        String(localized: "internal_dev.notifications.image.gitlab", defaultValue: "GitLabIcon", comment: "GitLab icon image name")
    ]

    private let availableColors: [(String, Color)] = [
        (String(localized: "internal_dev.notifications.color.red", defaultValue: "Red", comment: "Red color label"), .red),
        (String(localized: "internal_dev.notifications.color.orange", defaultValue: "Orange", comment: "Orange color label"), .orange),
        (String(localized: "internal_dev.notifications.color.yellow", defaultValue: "Yellow", comment: "Yellow color label"), .yellow),
        (String(localized: "internal_dev.notifications.color.green", defaultValue: "Green", comment: "Green color label"), .green),
        (String(localized: "internal_dev.notifications.color.mint", defaultValue: "Mint", comment: "Mint color label"), .mint),
        (String(localized: "internal_dev.notifications.color.cyan", defaultValue: "Cyan", comment: "Cyan color label"), .cyan),
        (String(localized: "internal_dev.notifications.color.teal", defaultValue: "Teal", comment: "Teal color label"), .teal),
        (String(localized: "internal_dev.notifications.color.blue", defaultValue: "Blue", comment: "Blue color label"), .blue),
        (String(localized: "internal_dev.notifications.color.indigo", defaultValue: "Indigo", comment: "Indigo color label"), .indigo),
        (String(localized: "internal_dev.notifications.color.purple", defaultValue: "Purple", comment: "Purple color label"), .purple),
        (String(localized: "internal_dev.notifications.color.pink", defaultValue: "Pink", comment: "Pink color label"), .pink),
        (String(localized: "internal_dev.notifications.color.gray", defaultValue: "Gray", comment: "Gray color label"), .gray)
    ]

    var body: some View {
        Section(String(localized: "internal_dev.notifications.section", defaultValue: "Notifications", comment: "Notifications section title")) {
            Toggle(String(localized: "internal_dev.notifications.delay_toggle", defaultValue: "Delay 5s", comment: "Delay 5 seconds toggle"), isOn: $delay)
            Toggle(String(localized: "internal_dev.notifications.sticky_toggle", defaultValue: "Sticky", comment: "Sticky notification toggle"), isOn: $sticky)

            Picker(String(localized: "internal_dev.notifications.icon_type_picker", defaultValue: "Icon Type", comment: "Icon type picker label"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "internal_dev.notifications.symbol_picker", defaultValue: "Symbol", comment: "Symbol picker label"), selection: $selectedSymbol) {
                        Label(String(localized: "internal_dev.notifications.random_label", defaultValue: "Random", comment: "Random option label"), systemImage: String(localized: "internal_dev.notifications.dice_symbol", defaultValue: "dice", comment: "Dice symbol")).tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "internal_dev.notifications.emoji_picker", defaultValue: "Emoji", comment: "Emoji picker label"), selection: $selectedEmoji) {
                        Label(String(localized: "internal_dev.notifications.random_label", defaultValue: "Random", comment: "Random option label"), systemImage: String(localized: "internal_dev.notifications.dice_symbol", defaultValue: "dice", comment: "Dice symbol")).tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "internal_dev.notifications.text_picker", defaultValue: "Text", comment: "Text picker label"), selection: $selectedText) {
                        Label(String(localized: "internal_dev.notifications.random_label", defaultValue: "Random", comment: "Random option label"), systemImage: String(localized: "internal_dev.notifications.dice_symbol", defaultValue: "dice", comment: "Dice symbol")).tag(nil as String?)
                        Divider()
                        ForEach(String(localized: "internal_dev.notifications.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet string for letter selection").map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "internal_dev.notifications.image_picker", defaultValue: "Image", comment: "Image picker label"), selection: $selectedImage) {
                        Label(String(localized: "internal_dev.notifications.random_label", defaultValue: "Random", comment: "Random option label"), systemImage: String(localized: "internal_dev.notifications.dice_symbol", defaultValue: "dice", comment: "Dice symbol")).tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "internal_dev.notifications.icon_color_picker", defaultValue: "Icon Color", comment: "Icon color picker label"), selection: $selectedColor) {
                        Label(String(localized: "internal_dev.notifications.random_label", defaultValue: "Random", comment: "Random option label"), systemImage: String(localized: "internal_dev.notifications.dice_symbol", defaultValue: "dice", comment: "Dice symbol")).tag(nil as Color?)
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

            TextField(String(localized: "internal_dev.notifications.title_field", defaultValue: "Title", comment: "Title text field label"), text: $notificationTitle)
            TextField(String(localized: "internal_dev.notifications.description_field", defaultValue: "Description", comment: "Description text field label"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "internal_dev.notifications.action_button_field", defaultValue: "Action Button", comment: "Action button text field label"), text: $actionButtonText)

            Button(String(localized: "internal_dev.notifications.add_button", defaultValue: "Add Notification", comment: "Add notification button")) {
                let action = {
                    switch selectedIconType {
                    case .symbol:
                        let iconSymbol = selectedSymbol ?? availableSymbols.randomElement() ?? String(localized: "internal_dev.notifications.symbol.bell_fill", defaultValue: "bell.fill", comment: "Bell fill symbol")
                        let iconColor = selectedColor ?? availableColors.randomElement()?.1 ?? .blue

                        NotificationManager.shared.post(
                            iconSymbol: iconSymbol,
                            iconColor: iconColor,
                            title: notificationTitle,
                            description: notificationDescription,
                            actionButtonTitle: actionButtonText,
                            action: {
                                print(String(localized: "internal_dev.notifications.test_action_triggered", defaultValue: "Test notification action triggered", comment: "Test notification action triggered message"))
                            },
                            isSticky: sticky
                        )
                    case .image:
                        let imageName = selectedImage ?? availableImages.randomElement() ?? String(localized: "internal_dev.notifications.image.github", defaultValue: "GitHubIcon", comment: "GitHub icon image name")

                        NotificationManager.shared.post(
                            iconImage: Image(imageName),
                            title: notificationTitle,
                            description: notificationDescription,
                            actionButtonTitle: actionButtonText,
                            action: {
                                print(String(localized: "internal_dev.notifications.test_action_triggered", defaultValue: "Test notification action triggered", comment: "Test notification action triggered message"))
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
                                print(String(localized: "internal_dev.notifications.test_action_triggered", defaultValue: "Test notification action triggered", comment: "Test notification action triggered message"))
                            },
                            isSticky: sticky
                        )
                    case .emoji:
                        let emoji = selectedEmoji ?? availableEmojis.randomElement() ?? String(localized: "internal_dev.notifications.emoji.bell", defaultValue: "🔔", comment: "Bell emoji")
                        let iconColor = selectedColor ?? availableColors.randomElement()?.1 ?? .blue

                        NotificationManager.shared.post(
                            iconText: emoji,
                            iconTextColor: .white,
                            iconColor: iconColor,
                            title: notificationTitle,
                            description: notificationDescription,
                            actionButtonTitle: actionButtonText,
                            action: {
                                print(String(localized: "internal_dev.notifications.test_action_triggered", defaultValue: "Test notification action triggered", comment: "Test notification action triggered message"))
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
        let letters = String(localized: "internal_dev.notifications.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet string for letter selection").map { String($0) }
        return letters.randomElement() ?? String(localized: "internal_dev.notifications.default_letter", defaultValue: "A", comment: "Default letter fallback")
    }
}
