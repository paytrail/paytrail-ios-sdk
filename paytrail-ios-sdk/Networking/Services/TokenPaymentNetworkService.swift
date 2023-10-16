//
//  TokenPaymentNetworkService.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.6.2023.
//

import Foundation


final class TokenPaymentNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, PayTrailError>) -> Void) {
    
        //        guard let urlRequest = createUrlRequet(from: request).0 else {
        //            let error = createUrlRequet(from: request).1 ?? PaytrailGenericError._default
        //            return completion(.failure(error))
        //        }
        
        guard let urlRequest = createUrlRequet(from: request).0 else {
            if let error = createUrlRequet(from: request).1 {
                return completion(.failure(error))
            }
            return
        }
        
        PTLogger.log(message: "Token request: \(urlRequest)", level: .debug)
                
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(PayTrailError(type: .createTokenPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil, message: error.localizedDescription)))
            }
            
            PTLogger.log(message: "Response: \(response.debugDescription)", level: .debug)
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                
                guard let error = data else {
                    return completion(.failure(PayTrailError(type: .createTokenPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil, message: error?.localizedDescription)))
                }
            
                do {
                    
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 404
                    
                    switch statusCode {
                    case 403:
                        // 403 - 3DS soft payment decline, the only place we need an error payload
                        let decodedError = try jsonDecode(of: TokenPaymentThreeDsReponse.self, data: error)
                        return completion(.failure(PayTrailError(type: .threeDsPaymentSoftDecline, code: statusCode, message: nil, payload: decodedError)))
                    default:
                        let decodedError = try jsonDecode(of: PaymentErrorResponse.self, data: error)
                        return completion(.failure(PayTrailError(type: .createTokenPayment, code: statusCode, message: decodedError.localizedDescription)))
                    }
                    
                } catch let error as NSError {
                    return completion(.failure(PayTrailError(type: .jsonDecode, code: (response as? HTTPURLResponse)?.statusCode, message: error.localizedDescription)))
                }
            }
            
            guard let data = data else {
                return completion(.failure(PayTrailError(type: .createTokenPayment, code: response.statusCode, message: error?.localizedDescription)))
            }
        
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(PayTrailError(type: .jsonDecode, code: response.statusCode, message: error.localizedDescription)))
            }
        }
        .resume()
    }
}
