//
//  Int+HexString.swift
//  CodeEdit
//
//  Created by Khan Winter on 6/13/25.
//

extension UInt {
    init?(hexString: String) {
        // Trim 0x if it's there
        let string = String(hexString.trimmingPrefix(String(localized: "utils.int.hex-string.prefix", defaultValue: "0x", comment: "Hexadecimal prefix used when parsing integer strings")))
        guard let value = UInt(string, radix: 16) else {
            return nil
        }
        self = value
    }
}

extension Int {
    init?(hexString: String) {
        // Trim 0x if it's there
        let string = String(hexString.trimmingPrefix(String(localized: "utils.int.hex-string.output-prefix", defaultValue: "0x", comment: "Hexadecimal prefix used when formatting integer strings")))
        guard let value = Int(string, radix: 16) else {
            return nil
        }
        self = value
    }
}
