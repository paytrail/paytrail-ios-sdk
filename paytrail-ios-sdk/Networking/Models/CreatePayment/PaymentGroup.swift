//
//  PaymentGroup.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

public struct PaymentGroup : Codable {
    let id : String?
    let name : String?
    let icon : String?
    let svg : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case icon = "icon"
        case svg = "svg"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        svg = try values.decodeIfPresent(String.self, forKey: .svg)
    }

}
