//
//  CreateTokenPaymentDataRequest.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 27.6.2023.
//

import Foundation

public struct CreateTokenPaymentDataRequest: DataRequest {
    
    typealias Response = TokenPaymentRequestResponse
    var headers: [String : String]
   
    var body: Data?
    var queryItems: [String : String] = [:]
    
    var specialHeader: [String : String]
    
    var path: String = ApiPaths.paymentsToken
    
    var method: HTTPMethod {
        HTTPMethod.post
    }
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(TokenPaymentRequestResponse.self, from: data)
    }
}
