//
//  TokenPaymentNetworkService.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.6.2023.
//

import Foundation


final class TokenPaymentNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
    
        guard let urlRequest = createUrlRequet(from: request).0 else {
            let error = createUrlRequet(from: request).1 ?? PaytrailGenericError._default
            return completion(.failure(error))
        }
        
        PTLogger.log(message: "Token request: \(urlRequest)", level: .debug)
                
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(PaytrailGenericError(type: .createTokenPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil, payload: error as PaytrailGenericError.Payload)))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                
                guard let error = data else {
                    return completion(.failure(PaytrailPaymentError(type: .createTokenPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil)))
                }
            
                do {
                    
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 404
                    
                    switch statusCode {
                    case 403:
                        // 403 - 3DS soft payment decline
                        let decodedError = try jsonDecode(of: TokenPaymentThreeDsReponse.self, data: error)
                        return completion(.failure(PaytrailTokenError(type: .threeDsPaymentSoftDecline, code: statusCode, payload: decodedError)))
                    default:
                        let decodedError = try jsonDecode(of: PaymentErrorResponse.self, data: error)
                        return completion(.failure(PaytrailPaymentError(type: .createTokenPayment, code: statusCode, payload: decodedError)))
                    }
                    
                } catch let error as NSError {
                    return completion(.failure(PaytrailGenericError(type: .jsonDecode, code: (response as? HTTPURLResponse)?.statusCode, payload: error)))
                }
            }
            
            guard let data = data else {
                return completion(.failure(PaytrailPaymentError(type: .createTokenPayment, code: response.statusCode, payload: nil)))
            }
        
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(PaytrailGenericError(type: .jsonDecode, code: response.statusCode, payload: error)))
            }
        }
        .resume()
    }
}
