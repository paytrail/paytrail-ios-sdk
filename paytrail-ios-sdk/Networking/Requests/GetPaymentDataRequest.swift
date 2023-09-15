//
//  GetPaymentDataRequest.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 16.6.2023.
//

import Foundation

struct GetPaymentDataRequest: DataRequest {
    
    typealias Response = Payment
    var queryItems: [String : String] = [:]
    var path: String
    var headers: [String : String]
    var specialHeader: [String : String]
    var body: Data? = nil
    
    var method: HTTPMethod {
        HTTPMethod.get
    }
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Payment.self, from: data)
    }
    
}


