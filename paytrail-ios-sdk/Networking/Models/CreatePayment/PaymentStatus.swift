//
//  PaymentStatus.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 12.6.2023.
//

import Foundation


/// PaymentStatus
///
/// PaymentStatus enum representing the different statuses of a payment
///
public enum PaymentStatus: String, Codable {
    case new
    case ok
    case fail
    case pending
    case delayed
    case none
}
