//
//  Int+HexString.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/13/25.
//

extension UInt {
    init?(hexString: String) {
        // Trim 0x if it's there
        let string = String(hexString.trimmingPrefix(String(localized: "hex.prefix", defaultValue: "0x", comment: "Hexadecimal prefix - technical constant, should not be localized")))
        guard let value = UInt(string, radix: 16) else {
            return nil
        }
        self = value
    }
}

extension Int {
    init?(hexString: String) {
        // Trim 0x if it's there
        let string = String(hexString.trimmingPrefix(String(localized: "hex.prefix-dup", defaultValue: "0x", comment: "Hexadecimal prefix - technical constant, should not be localized")))
        guard let value = Int(string, radix: 16) else {
            return nil
        }
        self = value
    }
}
