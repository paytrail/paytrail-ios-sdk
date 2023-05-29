//
//  Provider.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation

public struct Provider : Codable {
    let url : String?
    let icon : String?
    let svg : String?
    let name : String?
    let group : String?
    let id : String?
    let parameters : [Parameter]?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case icon = "icon"
        case svg = "svg"
        case name = "name"
        case group = "group"
        case id = "id"
        case parameters = "parameters"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        svg = try values.decodeIfPresent(String.self, forKey: .svg)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        group = try values.decodeIfPresent(String.self, forKey: .group)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        parameters = try values.decodeIfPresent([Parameter].self, forKey: .parameters)
    }
}
