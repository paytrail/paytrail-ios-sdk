//
//  NetworkService.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.5.2023.
//

import Foundation

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, PayTrailError>) -> Void)
}

extension NetworkService {
    func createUrlRequet<Request: DataRequest>(from request: Request) -> (URLRequest?, PayTrailError?) {
        guard var urlComponent = URLComponents(string: request.url) else {
            //            let error = PaytrailGenericError(type: .invalidEndpint, code: 404)
            let error = PayTrailError(type: .invalidEndpint, code: nil, message: nil)
            return (nil, error)
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            //            let error = PaytrailGenericError(type: .invalidEndpint, code: 404)
            let error = PayTrailError(type: .invalidEndpint, code: nil, message: nil)
            return (nil, error)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.combinedHeaders
        
        return (urlRequest, nil)
    }
}
