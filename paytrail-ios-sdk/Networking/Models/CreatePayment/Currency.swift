//
//  Currency.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 16.6.2023.
//

import Foundation


/// Currency
///
/// Currency enum. Currently only supports EUR
///
public enum Currency: String, Codable, CaseIterable {
    case eur = "EUR"
}
