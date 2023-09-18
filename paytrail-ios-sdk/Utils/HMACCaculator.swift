//
//  HMACCaculator.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 30.5.2023.
//

import Foundation
import CryptoKit
import CommonCrypto


/// Calculate HMAC signature of combined HTTP headers and body string. Rule: headers 'checkout-' with prefix are picked and sorted alphabetically; body data is encoded to string in UTF8. HMAC algorithm: SHA256.
///
/// - Parameters:
///   - secret: The secret used to calculate HMAC, i.e. the merchant's secret key
///   - headers: HTTP headers needed for calculation
///   - body: HTTP body needed for calculation
/// - Returns: The HMAC signature string
public func hmacSignature(secret: String, headers: [String: String], body: Data?) -> String {
    var headerArray: Array<String> = []
    headerArray = headers.filter { (key, value) in
        key.starts(with: "checkout-")
    }.map { (key, value) in
        key + ":" + String(value)
    }.sorted { $0 < $1 }
    
    if let data = body {
        let bodyString = String(data: data , encoding: .utf8)
        headerArray.append(bodyString ?? "")
    } else {
        headerArray.append("")
    }
    
    let message = headerArray.joined(separator: "\n")
    PTLogger.log(message: "Signature message: \(message)", level: .debug)
    
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), secret, secret.count, message, message.count, &digest)
    let data = Data(digest)
    let hmac = data.map { String(format: "%02hhx", $0) }.joined()
    PTLogger.log(message: "HMAC: \(hmac)", level: .debug)
    return hmac
}
