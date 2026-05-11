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
                return String(localized: "internal-dev.notifications.icon-type-symbol", defaultValue: "Symbol", comment: "Icon type option for symbol")
            case .image:
                return String(localized: "internal-dev.notifications.icon-type-image", defaultValue: "Image", comment: "Icon type option for image")
            case .text:
                return String(localized: "internal-dev.notifications.icon-type-text", defaultValue: "Text", comment: "Icon type option for text")
            case .emoji:
                return String(localized: "internal-dev.notifications.icon-type-emoji", defaultValue: "Emoji", comment: "Icon type option for emoji")
            }
        }
    }

    @State private var delay: Bool = false
    @State private var sticky: Bool = false
    @State private var selectedIconType: IconType = .symbol
    @State private var actionButtonText: String = String(localized: "internal-dev.notifications.action-button-default", defaultValue: "View", comment: "Default text for action button")
    @State private var notificationTitle: String = String(localized: "internal-dev.notifications.title-default", defaultValue: "Test Notification", comment: "Default notification title")
    @State private var notificationDescription: String = String(localized: "internal-dev.notifications.description-default", defaultValue: "This is a test notification.", comment: "Default notification description")

    // Icon selection states
    @State private var selectedSymbol: String?
    @State private var selectedEmoji: String?
    @State private var selectedText: String?
    @State private var selectedImage: String?
    @State private var selectedColor: Color?

    private let availableSymbols = [
        String(localized: "internal-dev.notifications.symbol-bell-fill", defaultValue: "bell.fill", comment: "SF Symbol name for bell fill"),
        String(localized: "internal-dev.notifications.symbol-bell-badge-fill", defaultValue: "bell.badge.fill", comment: "SF Symbol name for bell badge fill"),
        String(localized: "internal-dev.notifications.symbol-exclamation-triangle-fill", defaultValue: "exclamationmark.triangle.fill", comment: "SF Symbol name for exclamation triangle fill"),
        String(localized: "internal-dev.notifications.symbol-info-circle-fill", defaultValue: "info.circle.fill", comment: "SF Symbol name for info circle fill"),
        String(localized: "internal-dev.notifications.symbol-checkmark-seal-fill", defaultValue: "checkmark.seal.fill", comment: "SF Symbol name for checkmark seal fill"),
        String(localized: "internal-dev.notifications.symbol-xmark-octagon-fill", defaultValue: "xmark.octagon.fill", comment: "SF Symbol name for xmark octagon fill"),
        String(localized: "internal-dev.notifications.symbol-bubble-left-fill", defaultValue: "bubble.left.fill", comment: "SF Symbol name for bubble left fill"),
        String(localized: "internal-dev.notifications.symbol-envelope-fill", defaultValue: "envelope.fill", comment: "SF Symbol name for envelope fill"),
        String(localized: "internal-dev.notifications.symbol-phone-fill", defaultValue: "phone.fill", comment: "SF Symbol name for phone fill"),
        String(localized: "internal-dev.notifications.symbol-megaphone-fill", defaultValue: "megaphone.fill", comment: "SF Symbol name for megaphone fill"),
        String(localized: "internal-dev.notifications.symbol-clock-fill", defaultValue: "clock.fill", comment: "SF Symbol name for clock fill"),
        String(localized: "internal-dev.notifications.symbol-calendar", defaultValue: "calendar", comment: "SF Symbol name for calendar"),
        String(localized: "internal-dev.notifications.symbol-flag-fill", defaultValue: "flag.fill", comment: "SF Symbol name for flag fill"),
        String(localized: "internal-dev.notifications.symbol-bookmark-fill", defaultValue: "bookmark.fill", comment: "SF Symbol name for bookmark fill"),
        String(localized: "internal-dev.notifications.symbol-bolt-fill", defaultValue: "bolt.fill", comment: "SF Symbol name for bolt fill"),
        String(localized: "internal-dev.notifications.symbol-shield-lefthalf-fill", defaultValue: "shield.lefthalf.fill", comment: "SF Symbol name for shield lefthalf fill"),
        String(localized: "internal-dev.notifications.symbol-gift-fill", defaultValue: "gift.fill", comment: "SF Symbol name for gift fill"),
        String(localized: "internal-dev.notifications.symbol-heart-fill", defaultValue: "heart.fill", comment: "SF Symbol name for heart fill"),
        String(localized: "internal-dev.notifications.symbol-star-fill", defaultValue: "star.fill", comment: "SF Symbol name for star fill"),
        String(localized: "internal-dev.notifications.symbol-curlybraces", defaultValue: "curlybraces", comment: "SF Symbol name for curlybraces")
    ]

    private let availableEmojis = [
        String(localized: "internal-dev.notifications.emoji-bell", defaultValue: "🔔", comment: "Bell emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-siren", defaultValue: "🚨", comment: "Siren emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-warning", defaultValue: "⚠️", comment: "Warning emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-wave", defaultValue: "👋", comment: "Wave emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-heart-eyes", defaultValue: "😍", comment: "Heart eyes emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-sunglasses", defaultValue: "😎", comment: "Sunglasses emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-kiss", defaultValue: "😘", comment: "Kiss emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-wink-tongue", defaultValue: "😜", comment: "Wink tongue emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-squint-tongue", defaultValue: "😝", comment: "Squint tongue emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-grin", defaultValue: "😀", comment: "Grin emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-beam", defaultValue: "😁", comment: "Beam emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-tears", defaultValue: "😂", comment: "Tears of joy emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-rofl", defaultValue: "🤣", comment: "ROFL emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-smile", defaultValue: "😃", comment: "Smile emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-happy", defaultValue: "😄", comment: "Happy emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-sweat-smile", defaultValue: "😅", comment: "Sweat smile emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-laughing", defaultValue: "😆", comment: "Laughing emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-innocent", defaultValue: "😇", comment: "Innocent emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-wink", defaultValue: "😉", comment: "Wink emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-blush", defaultValue: "😊", comment: "Blush emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-yum", defaultValue: "😋", comment: "Yum emoji for notifications"),
        String(localized: "internal-dev.notifications.emoji-relieved", defaultValue: "😌", comment: "Relieved emoji for notifications")
    ]

    private let availableImages = [
        String(localized: "internal-dev.notifications.image-github", defaultValue: "GitHubIcon", comment: "GitHub icon for notifications"),
        String(localized: "internal-dev.notifications.image-bitbucket", defaultValue: "BitBucketIcon", comment: "BitBucket icon for notifications"),
        String(localized: "internal-dev.notifications.image-gitlab", defaultValue: "GitLabIcon", comment: "GitLab icon for notifications")
    ]

    private let availableColors: [(String, Color)] = [
        (String(localized: "internal-dev.notifications.color-red", defaultValue: "Red", comment: "Red color option"), .red),
        (String(localized: "internal-dev.notifications.color-orange", defaultValue: "Orange", comment: "Orange color option"), .orange),
        (String(localized: "internal-dev.notifications.color-yellow", defaultValue: "Yellow", comment: "Yellow color option"), .yellow),
        (String(localized: "internal-dev.notifications.color-green", defaultValue: "Green", comment: "Green color option"), .green),
        (String(localized: "internal-dev.notifications.color-mint", defaultValue: "Mint", comment: "Mint color option"), .mint),
        (String(localized: "internal-dev.notifications.color-cyan", defaultValue: "Cyan", comment: "Cyan color option"), .cyan),
        (String(localized: "internal-dev.notifications.color-teal", defaultValue: "Teal", comment: "Teal color option"), .teal),
        (String(localized: "internal-dev.notifications.color-blue", defaultValue: "Blue", comment: "Blue color option"), .blue),
        (String(localized: "internal-dev.notifications.color-indigo", defaultValue: "Indigo", comment: "Indigo color option"), .indigo),
        (String(localized: "internal-dev.notifications.color-purple", defaultValue: "Purple", comment: "Purple color option"), .purple),
        (String(localized: "internal-dev.notifications.color-pink", defaultValue: "Pink", comment: "Pink color option"), .pink),
        (String(localized: "internal-dev.notifications.color-gray", defaultValue: "Gray", comment: "Gray color option"), .gray)
    ]

    var body: some View {
        Section(String(localized: "internal-dev.notifications.section-title", defaultValue: "Notifications", comment: "Section title for notifications settings")) {
            Toggle(String(localized: "internal-dev.notifications.delay-toggle", defaultValue: "Delay 5s", comment: "Toggle for 5 second notification delay"), isOn: $delay)
            Toggle(String(localized: "internal-dev.notifications.sticky-toggle", defaultValue: "Sticky", comment: "Toggle for sticky notifications"), isOn: $sticky)

            Picker(String(localized: "internal-dev.notifications.icon-type-picker", defaultValue: "Icon Type", comment: "Picker label for icon type selection"), selection: $selectedIconType) {
                ForEach(IconType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }

            Group {
                switch selectedIconType {
                case .symbol:
                    Picker(String(localized: "internal-dev.notifications.symbol-picker", defaultValue: "Symbol", comment: "Picker label for symbol selection"), selection: $selectedSymbol) {
                        Label(String(localized: "internal-dev.notifications.random-option", defaultValue: "Random", comment: "Option for random selection"), systemImage: String(localized: "internal-dev.notifications.random-icon", defaultValue: "dice", comment: "SF Symbol for random icon")).tag(nil as String?)
                        Divider()
                        ForEach(availableSymbols, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol).tag(symbol as String?)
                        }
                    }
                case .emoji:
                    Picker(String(localized: "internal-dev.notifications.emoji-picker", defaultValue: "Emoji", comment: "Picker label for emoji selection"), selection: $selectedEmoji) {
                        Label(String(localized: "internal-dev.notifications.random-option", defaultValue: "Random", comment: "Option for random selection"), systemImage: String(localized: "internal-dev.notifications.random-icon", defaultValue: "dice", comment: "SF Symbol for random icon")).tag(nil as String?)
                        Divider()
                        ForEach(availableEmojis, id: \.self) { emoji in
                            Text(emoji).tag(emoji as String?)
                        }
                    }
                case .text:
                    Picker(String(localized: "internal-dev.notifications.text-picker", defaultValue: "Text", comment: "Picker label for text selection"), selection: $selectedText) {
                        Label(String(localized: "internal-dev.notifications.random-option", defaultValue: "Random", comment: "Option for random selection"), systemImage: String(localized: "internal-dev.notifications.random-icon", defaultValue: "dice", comment: "SF Symbol for random icon")).tag(nil as String?)
                        Divider()
                        ForEach(String(localized: "internal-dev.notifications.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet string for text options").map { String($0) }, id: \.self) { letter in
                            Text(letter).tag(letter as String?)
                        }
                    }
                case .image:
                    Picker(String(localized: "internal-dev.notifications.image-picker", defaultValue: "Image", comment: "Picker label for image selection"), selection: $selectedImage) {
                        Label(String(localized: "internal-dev.notifications.random-option", defaultValue: "Random", comment: "Option for random selection"), systemImage: String(localized: "internal-dev.notifications.random-icon", defaultValue: "dice", comment: "SF Symbol for random icon")).tag(nil as String?)
                        Divider()
                        ForEach(availableImages, id: \.self) { image in
                            Text(image).tag(image as String?)
                        }
                    }
                }

                if selectedIconType == .symbol || selectedIconType == .text || selectedIconType == .emoji {
                    Picker(String(localized: "internal-dev.notifications.icon-color-picker", defaultValue: "Icon Color", comment: "Picker label for icon color selection"), selection: $selectedColor) {
                        Label(String(localized: "internal-dev.notifications.random-option", defaultValue: "Random", comment: "Option for random selection"), systemImage: String(localized: "internal-dev.notifications.random-icon", defaultValue: "dice", comment: "SF Symbol for random icon")).tag(nil as Color?)
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

            TextField(String(localized: "internal-dev.notifications.title-field", defaultValue: "Title", comment: "Text field label for notification title"), text: $notificationTitle)
            TextField(String(localized: "internal-dev.notifications.description-field", defaultValue: "Description", comment: "Text field label for notification description"), text: $notificationDescription, axis: .vertical)
                .lineLimit(1...5)
            TextField(String(localized: "internal-dev.notifications.action-button-field", defaultValue: "Action Button", comment: "Text field label for action button text"), text: $actionButtonText)

            Button(String(localized: "internal-dev.notifications.add-button", defaultValue: "Add Notification", comment: "Button to add a test notification")) {
                let action = {
                    switch selectedIconType {
                    case .symbol:
                        let iconSymbol = selectedSymbol ?? availableSymbols.randomElement() ?? String(localized: "internal-dev.notifications.default-symbol", defaultValue: "bell.fill", comment: "Default symbol for notifications")
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
                        let imageName = selectedImage ?? availableImages.randomElement() ?? String(localized: "internal-dev.notifications.default-image", defaultValue: "GitHubIcon", comment: "Default image for notifications")

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
                        let emoji = selectedEmoji ?? availableEmojis.randomElement() ?? String(localized: "internal-dev.notifications.default-emoji", defaultValue: "🔔", comment: "Default emoji for notifications")
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
        let letters = String(localized: "internal-dev.notifications.alphabet", defaultValue: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", comment: "Alphabet string for text options").map { String($0) }
        return letters.randomElement() ?? String(localized: "internal-dev.notifications.default-letter", defaultValue: "A", comment: "Default letter for text notifications")
    }
}
