//
//  HMACCaculator.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 30.5.2023.
//

import Foundation
import CryptoKit
import CommonCrypto

public func hmacSignature(secret: String, headers: [String: String], body: [String: Any]) -> String {
    var headerArray: Array<String> = []
    headerArray = headers.filter { (key, value) in
        key.starts(with: "checkout-")
    }.map { (key, value) in
        key + ":" + String(value)
    }
    
    do {
        let data = try JSONSerialization.data(withJSONObject: body)
        let bodyString = String(data: data , encoding: .utf8)
        headerArray.append(bodyString ?? "")
    } catch {
        print("Invalid request body")
    }
    
    let message = headerArray.joined(separator: "\n")
    print(message)
    let hmac = hmacCaculator(secret: secret, message: message)
    print(hmac)
    return hmac
}

func hmacCaculator(secret: String, message: String) -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), secret, secret.count, message, message.count, &digest)
    let data = Data(digest)
    return data.map { String(format: "%02hhx", $0) }.joined()
}
