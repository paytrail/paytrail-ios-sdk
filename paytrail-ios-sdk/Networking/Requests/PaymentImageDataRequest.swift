//
//  PaymentImageDataRequest.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 8.6.2023.
//

import Foundation
import UIKit

struct PaymentImageDataRequest: DataRequest {
    var body: Data? = nil
    var queryItems: [String : String] = [:]
    var specialHeader: [String : String] = [:]
    var headers: [String : String] = [:]
    let url: String
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NSError(
                domain: "Decode image error",
                code: NSURLErrorDownloadDecodingFailedToComplete,
                userInfo: nil
            )
        }
        return image
    }
}
