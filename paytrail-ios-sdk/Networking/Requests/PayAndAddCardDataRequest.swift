//
//  PayAndAddCardDataRequest.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 22.8.2023.
//

import Foundation

public struct PayAndAddCardDataRequest: DataRequest {
    
    typealias Response = PayAndAddCardRequestResponse
    var headers: [String : String]
   
    var body: Data?
    var queryItems: [String : String] = [:]
    
    var specialHeader: [String : String]
    
    var path: String = ApiPaths.tokenization + ApiPaths.payAndAddCard
    
    var method: HTTPMethod {
        HTTPMethod.post
    }
    
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(PayAndAddCardRequestResponse.self, from: data)
    }
}
