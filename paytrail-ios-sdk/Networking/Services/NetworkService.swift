//
//  NetworkService.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.5.2023.
//

import Foundation

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

extension NetworkService {
    func createUrlRequet<Request: DataRequest>(from request: Request) -> (URLRequest?, (any PaytrailError)?) {
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = PaytrailGenericError(type: .invalidEndpint, code: 404)
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
            let error = PaytrailGenericError(type: .invalidEndpint, code: 404)
            return (nil, error)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.combinedHeaders
        
        return (urlRequest, nil)
    }
}

final class DefaultNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard let urlRequest = createUrlRequet(from: request).0 else {
            let error = createUrlRequet(from: request).1 ?? PaytrailGenericError._default
            return completion(.failure(error))
        }
                
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(PaytrailGenericError(type: .unknown, code: (response as? HTTPURLResponse)?.statusCode ?? nil, payload: error as PaytrailGenericError.Payload)))
            }
            
            //            PTLogger.log(message: "\(response)", level: .debug)
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
            
                guard let _ = data else {
                    let error = PaytrailGenericError(type: .unknown, code: (response as? HTTPURLResponse)?.statusCode ?? nil, payload: nil)
                    return completion(.failure(error))
                }
                
                return completion(.failure(PaytrailGenericError(type: .unknown, code: (response as? HTTPURLResponse)?.statusCode ?? nil, payload: nil)))
                
            }
            
            guard let data = data else {
                return completion(.failure(PaytrailGenericError(type: .unknown, code: response.statusCode, payload: nil)))
            }
        
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(PaytrailGenericError(type: .unknown, code: response.statusCode, payload: error)))
            }
        }
        .resume()
    }
}
