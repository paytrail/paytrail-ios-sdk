//
//  Card.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 21.6.2023.
//

import Foundation


/// Card data model representing a payment card, retrieved after a successful card tokenization request.
///
public struct Card: Codable {

    /** Card type, for example ‘Visa’ */
    public var type: String?
    /** Last four digits of the card */
    public var partialPan: String?
    /** Card expiration year */
    public var expireYear: String?
    /** Card expiration month */
    public var expireMonth: String?
    /** Whether the CVC is required for paying with this card. Can be one of yes, no or not_tested. */
    public var cvcRequired: CvcRequired?
    /** First 2 or 6 digits of the card number. (6 MC/VISA, 2 Amex/Diners) */
    public var bin: String?
    /** credit, debit or unknown */
    public var funding: Funding?
    /** e.g. FI */
    public var countryCode: String
    /** business, prepaid or unknown */
    public var category: Category?
    /** Identifies a specific card number. Cards with the same PAN but different expiry dates will have the same PAN fingerprint. Hex string of length 64. */
    public var cardFingerprint: String?
    /** Identifies a specific card, including the expiry date. Hex string of length 64. */
    public var panFingerprint: String?

    public init(type: String? = nil, partialPan: String? = nil, expireYear: String? = nil, expireMonth: String? = nil, cvcRequired: CvcRequired? = nil, bin: String? = nil, funding: Funding? = nil, countryCode: String, category: Category? = nil, cardFingerprint: String? = nil, panFingerprint: String? = nil) {
        self.type = type
        self.partialPan = partialPan
        self.expireYear = expireYear
        self.expireMonth = expireMonth
        self.cvcRequired = cvcRequired
        self.bin = bin
        self.funding = funding
        self.countryCode = countryCode
        self.category = category
        self.cardFingerprint = cardFingerprint
        self.panFingerprint = panFingerprint
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case type
        case partialPan = "partial_pan"
        case expireYear = "expire_year"
        case expireMonth = "expire_month"
        case cvcRequired = "cvc_required"
        case bin
        case funding
        case countryCode = "country_code"
        case category
        case cardFingerprint = "card_fingerprint"
        case panFingerprint = "pan_fingerprint"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(partialPan, forKey: .partialPan)
        try container.encodeIfPresent(expireYear, forKey: .expireYear)
        try container.encodeIfPresent(expireMonth, forKey: .expireMonth)
        try container.encodeIfPresent(cvcRequired, forKey: .cvcRequired)
        try container.encodeIfPresent(bin, forKey: .bin)
        try container.encodeIfPresent(funding, forKey: .funding)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(cardFingerprint, forKey: .cardFingerprint)
        try container.encodeIfPresent(panFingerprint, forKey: .panFingerprint)
    }
}

public enum Funding: String, Codable {
    case credit, debit, unknown
}

public enum CvcRequired: String, Codable {
    case yes, no, not_tested
}

public enum Category: String, Codable {
    case business, prepaid, unknown
}
