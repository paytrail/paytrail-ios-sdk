//
//  DateHandler.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 21.6.2023.
//

import Foundation

func getCurrentDateIsoString() -> String {
    let iso8601DateFormatter = ISO8601DateFormatter()
    iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return iso8601DateFormatter.string(from: Date())
}
