//
//  NotificationManager+Delegate.swift
//  CodeEdit
//
//  Created by Austin Condiff on 2/14/24.
//

import AppKit
import UserNotifications

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if let notification = notifications.first(where: {
            $0.id.uuidString == response.notification.request.identifier
        }) {
            // Focus CodeEdit and run action if action button was clicked
            if response.actionIdentifier == String(localized: "notification.action_button_id", defaultValue: "ACTION_BUTTON", comment: "Notification action button identifier") ||
               response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                NSApp.activate(ignoringOtherApps: true)
                notification.action()
            }

            // Remove the notification for both action and dismiss
            if response.actionIdentifier == String(localized: "notification.action_button_id", defaultValue: "ACTION_BUTTON", comment: "Notification action button identifier") ||
               response.actionIdentifier == UNNotificationDefaultActionIdentifier ||
               response.actionIdentifier == UNNotificationDismissActionIdentifier {
                dismissNotification(notification)
            }
        }

        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    func setupNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = self

        // Create action button
        let action = UNNotificationAction(
            identifier: String(localized: "notification.action_button_id", defaultValue: "ACTION_BUTTON", comment: "Notification action button identifier"),
            title: String(localized: "notification.action_button", defaultValue: "Action", comment: "Notification action button title"),
            options: .foreground
        )

        // Create category with action button
        let actionCategory = UNNotificationCategory(
            identifier: String(localized: "notification.actionable_category", defaultValue: "ACTIONABLE", comment: "Actionable notification category identifier"),
            actions: [action],
            intentIdentifiers: [],
            options: .customDismissAction
        )

        UNUserNotificationCenter.current().setNotificationCategories([actionCategory])
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
}
