//
//  NormalPaymentNetworkService.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.6.2023.
//

import Foundation

final class NormalPaymentNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, PayTrailError>) -> Void) {
        
        guard let urlRequest = createUrlRequet(from: request).0 else {
            //            let error = createUrlRequet(from: request).1 ?? PaytrailGenericError._default
            if let error = createUrlRequet(from: request).1 {
                return completion(.failure(error))
            }
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(PayTrailError(type: .createPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil, message: error.localizedDescription)))
            }
            
            PTLogger.log(message: "Response: \(response.debugDescription)", level: .debug)

            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                
                // Treat data as error when falling out of the success response code range
                guard let error = data else {
                    let error = PayTrailError(type: .createPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil, message: error?.localizedDescription)
                    return completion(.failure(error))
                }
                
                do {
                    let decodedError = try jsonDecode(of: PaymentErrorResponse.self, data: error)
                    let paymentError = PayTrailError(type: .createPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil, message: decodedError.localizedDescription)
                    //                    return completion(.failure(PaytrailPaymentError(type: .createPayment, code: (response as? HTTPURLResponse)?.statusCode ?? nil, payload: decodedError)))
                    return completion(.failure(paymentError))
                } catch let error as NSError {
                    return completion(.failure(PayTrailError(type: .jsonDecode, code: (response as? HTTPURLResponse)?.statusCode ?? nil, message: error.localizedDescription)))
                }
            }
            
            guard let data = data else {
                // Return failure when data is missing
                return completion(.failure(PayTrailError(type: .createPayment, code: response.statusCode, message: nil)))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                //                error.localizedDescription
                return completion(.failure(PayTrailError(type: .jsonDecode, code: response.statusCode, message: error.localizedDescription)))
            }
            
        }
        .resume()
        
    }
    
}
