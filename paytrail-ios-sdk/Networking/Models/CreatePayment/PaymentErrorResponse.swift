//
//  PaymentError.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 30.5.2023.
//

import Foundation


/// PaymentErrorResponse
///
/// PaymentErrorResponse data model containing a status and a message
///
public struct PaymentErrorResponse: Codable {
    
    /// Status of the reponse
    let status: String?
    
    /// Error message
    let message: String?
    
    var localizedDescription: String {
        guard let status = status, let message = message else {
            return ""
        }
        return "{status: \(status), message: \(message)}"
    }
    
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
