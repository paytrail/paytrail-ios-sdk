//
//  Payment.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 16.6.2023.
//

import Foundation


/// Payment data model returned from an existing payment transaction,
/// see API 'getPayment(of:secret:transactionId:completion:)'.
///
public struct Payment: Codable {

    /** Transaction ID */
    public var transactionId: String?
    /** Transaction status */
    public var status: PaymentStatus?
    public var amount: Int?
    public var currency: Currency?
    public var stamp: String?
    public var reference: String?
    public var createdAt: String?
    /** If transaction is in status 'new', link to the hosted payment gateway */
    public var href: String?
    /** If processed, the name of the payment method provider */
    public var provider: String?
    /** If paid, the filing code issued by the payment method provider if any */
    public var filingCode: String?
    /** Timestamp when the transaction was paid */
    public var paidAt: String?
    
    public init(transactionId: String? = nil,
                status: PaymentStatus? = nil,
                amount: Int? = nil,
                currency: Currency? = nil,
                stamp: String? = nil,
                reference: String? = nil,
                createdAt: String? = nil,
                href: String? = nil,
                provider: String? = nil,
                filingCode: String? = nil,
                paidAt: String? = nil) {
        self.transactionId = transactionId
        self.status = status
        self.amount = amount
        self.currency = currency
        self.stamp = stamp
        self.reference = reference
        self.createdAt = createdAt
        self.href = href
        self.provider = provider
        self.filingCode = filingCode
        self.paidAt = paidAt
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case transactionId
        case status
        case amount
        case currency
        case stamp
        case reference
        case createdAt
        case href
        case provider
        case filingCode
        case paidAt
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        status = try values.decodeIfPresent(PaymentStatus.self, forKey: .status)
        amount = try values.decodeIfPresent(Int.self, forKey: .amount)
        currency = try values.decodeIfPresent(Currency.self, forKey: .currency)
        stamp = try values.decodeIfPresent(String.self, forKey: .stamp)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        createdAt =  try values.decodeIfPresent(String.self, forKey: .createdAt)
        href = try values.decodeIfPresent(String.self, forKey: .href)
        provider = try values.decodeIfPresent(String.self, forKey: .provider)
        filingCode = try values.decodeIfPresent(String.self, forKey: .filingCode)
        paidAt = try values.decodeIfPresent(String.self, forKey: .paidAt)
    }

}
