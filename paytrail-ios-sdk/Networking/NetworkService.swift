//
//  NetworkService.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.5.2023.
//

import Foundation

// TODO: refactor this service
protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class TokenPaymentNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
    
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(
                domain: "Invalid endpoint",
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(
                domain: "Invalid endpoint",
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.combinedHeaders
        //        print(request.combinedHeaders)
                
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                
                guard let error = data else {
                    return completion(.failure(NSError(domain: "Payment Error", code: (response as? HTTPURLResponse)?.statusCode ?? 401, userInfo: nil)))
                }
            
                do {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                        return completion(.failure(NSError(domain: "Payment Error", code: 401, userInfo: ["info": error])))
                    }
                    
                    switch statusCode {
                    case 403:
                        // 403 - 3DS soft payment decline
                        let decodedError = try jsonDecode(of: TokenPaymentThreeDsReponse.self, data: error)
                        return completion(.failure(NSError(domain: "3DS soft payment decline", code: statusCode, userInfo: ["info": decodedError])))
                    default:
                        let decodedError = try jsonDecode(of: PaymentError.self, data: error)
                        return completion(.failure(NSError(domain: "Token Payment Error", code: statusCode, userInfo: ["info": decodedError])))
                    }
                    
                } catch let error as NSError {
                    return completion(.failure(NSError(domain: "Payment Error", code: (response as? HTTPURLResponse)?.statusCode ?? 401, userInfo: ["info": error])))
                }
            }
            
            guard let data = data else {
                return completion(.failure(NSError(domain: "Payment Error", code: response.statusCode, userInfo: nil)))
            }
        
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

final class DefaultNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
    
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(
                domain: "Invalid endpoint",
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(
                domain: "Invalid endpoint",
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.combinedHeaders
        //        print(request.combinedHeaders)
                
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                
                guard let error = data else {
                    return completion(.failure(NSError(domain: "Payment Error", code: (response as? HTTPURLResponse)?.statusCode ?? 401, userInfo: nil)))
                }
            
                do {
                    let decodedError = try jsonDecode(of: PaymentError.self, data: error)
                    return completion(.failure(NSError(domain: "Payment Error", code: (response as? HTTPURLResponse)?.statusCode ?? 401, userInfo: ["info": decodedError])))
                } catch let error as NSError {
                    return completion(.failure(NSError(domain: "Payment Error", code: (response as? HTTPURLResponse)?.statusCode ?? 401, userInfo: ["info": error])))
                }
            }
            
            guard let data = data else {
                return completion(.failure(NSError(domain: "Payment Error", code: response.statusCode, userInfo: nil)))
            }
        
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
