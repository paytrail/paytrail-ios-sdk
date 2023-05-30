//
//  PaymentError.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 30.5.2023.
//

import Foundation

public struct PaymentError: Codable {
    let status: String?
    let message: String?
    
    public init(status: String, message: String) {
        self.status = status
        self.message = message
    }
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try? values.decodeIfPresent(String.self, forKey: .status)
        message = try? values.decodeIfPresent(String.self, forKey: .message)
    }
}
