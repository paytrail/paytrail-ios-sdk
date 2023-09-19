//
//  PaymentMethodProvider.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.5.2023.
//

import Foundation


/// PaymentMethodProvider
///
/// PaymentMethodProvider data model used in MSDK'S PaymentProvidersView. Feel free to use it in your own views.
/// 
public struct PaymentMethodProvider: Codable, Equatable, Identifiable, Hashable {
    
    /// Target URL to load in a webview. Use POST as method.
    public let url : String?
    
    /// URL to PNG version of the provider icon
    public let icon : String?
    
    /// URL to SVG version of the provider icon. Using the SVG icon is preferred.
    public let svg : String?
    
    /// Display name of the provider.
    public let name : String?
    
    /// Provider group id. Provider groups allow presenting same type of providers in separate groups which usually makes it easier for the customer to select a payment method.
    public let group : String?
    
    /// ID of the provider
    public let id : String?
    
    /// Array of header fields
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
