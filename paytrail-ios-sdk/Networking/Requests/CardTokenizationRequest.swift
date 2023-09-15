//
//  CardTokenizationRequest.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 21.6.2023.
//

import Foundation

struct CardTokenizationRequest: DataRequest {
    typealias Response = TokenizationRequestResponse
    
    var path: String
    
    var headers: [String: String]
    
    var specialHeader: [String: String]
    
    var method: HTTPMethod {
        HTTPMethod.post
    }
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(TokenizationRequestResponse.self, from: data)
    }
}
