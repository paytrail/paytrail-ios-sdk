//
//  PaymentStatus.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 12.6.2023.
//

import Foundation

public enum PaymentStatus: String {
    case new
    case ok
    case fail
    case pending
    case delayed
    case none
}
