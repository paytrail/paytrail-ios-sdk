//
//  NetworkMethods.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.5.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest {
    associatedtype Response
    var url: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    var body: [String: Any] { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    
    var url: String {
        "https://services.paytrail.com" + path
    }
    
    var path: String {
        ""
    }
    
    var headers: [String : String] {
        ["content-type" : "application/json; charset=utf-8"]
    }
    
    var queryItems: [String : String] {
        [:]
    }
    
    var body: [String : Any] {
        [:]
    }
}
