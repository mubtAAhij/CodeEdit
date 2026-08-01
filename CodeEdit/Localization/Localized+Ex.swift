import SwiftUI

extension String {
    func localized(_ custom: String? = nil) -> LocalizedStringKey {
        if let custom {
            return LocalizedStringKey(custom)
        } else {
            return LocalizedStringKey(self)
        }
    }
}

extension LocalizedStringKey {
    static let helloWorld = String(localized: "localization.example", defaultValue: "Hello, world!", comment: "Example localized string").localized()
}
