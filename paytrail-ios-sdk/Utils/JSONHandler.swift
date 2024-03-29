//
//  JSONHandler.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 30.5.2023.
//

import Foundation

func jsonEncode<T>(of encodable: T) -> [String: Any] where T: Encodable {
    guard let encoded = try? JSONEncoder().encode(encodable) else {
        return [:]
    }
    let dict = try? JSONSerialization.jsonObject(with: encoded, options: .mutableContainers) as? [String: Any]
    return dict ?? [:]
}

func jsonDecode<T>(of type: T.Type, data: Data) throws -> T where T: Decodable {
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
}
