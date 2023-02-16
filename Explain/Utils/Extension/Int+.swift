//
//  String+.swift
//  Explain
//
//  Created by 이병현 on 2023/02/16.
//

import Foundation

extension Int {
    func currencyKR() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko")
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
