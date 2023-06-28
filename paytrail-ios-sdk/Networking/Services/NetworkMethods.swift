//
//  NetworkMethods.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.5.2023.
//

import Foundation

let baseUrl: String = "https://services.paytrail.com"

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
    var path: String { get set }
    var method: HTTPMethod { get }
    var specialHeader: [String: String] { get set }
    var headers: [String : String] { get set}
    var queryItems: [String : String] { get set }
    var body: Data? { get set }
    
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
        baseUrl + path
    }
    
    var path: String {
        ""
    }
    
    var headers: [String: String] {
        get { [:] }
        set { headers = [:] }
    }
    
    var queryItems: [String : String] {
        get { [:] }
        set { queryItems = [:] }
    }
    
    var body: Data? {
        get { nil }
        set { body = nil }
    }
    
    var combinedHeaders: [String: String] {
        let defaultHeader = ["content-type": "application/json; charset=utf-8"]
        let combinedHeaders = headers.merging(defaultHeader, uniquingKeysWith: { (first, _) in first }).merging(specialHeader, uniquingKeysWith: { (first, _) in first })
        return combinedHeaders
    }
}

