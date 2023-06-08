//
//  PaymentMethodProvider.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// PaymentMethodProvider
///
/// Each payment method provider object describes an HTML form. The payment method parameters need to be posted to defined url in application/x-www-form-urlencoded format.
///
/// - Properties:
///  - url: String? // Form action url
///  - icon: String? // URL to payment method PNG icon
///  - svg: String? // RL to payment method SVG icon (recommended to be used instead if PNG)
///  - name: String? // Display name of the payment method
///  - group: String? // Payment method group type, see PaymentType
///  - id: String? // ID of the provider
///  - parameters: [Parameter]? // See Parameter
/// 
public struct PaymentMethodProvider: Codable, Equatable, Identifiable {
    public let url : String?
    public let icon : String?
    public let svg : String?
    public let name : String?
    public let group : String?
    public let id : String?
    public let parameters : [Parameter]?

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case icon = "icon"
        case svg = "svg"
        case name = "name"
        case group = "group"
        case id = "id"
        case parameters = "parameters"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        svg = try values.decodeIfPresent(String.self, forKey: .svg)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        group = try values.decodeIfPresent(String.self, forKey: .group)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        parameters = try values.decodeIfPresent([Parameter].self, forKey: .parameters)
    }
    
    public static func == (lhs: PaymentMethodProvider, rhs: PaymentMethodProvider) -> Bool {
        lhs.id == rhs.id
    }
}
