//
//  TokenizedCard.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 21.6.2023.
//

import Foundation
import RealmSwift

class TokenizedCard: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var token: String
    @Persisted var customer: TokenCustomer?
    @Persisted var type: String
    @Persisted var partialPan: String
    @Persisted var expireYear: String
    @Persisted var expireMonth: String
    @Persisted var cvcRequired: String
    @Persisted var bin: String
    @Persisted var funding: String
    @Persisted var countryCode: String
    @Persisted var category: String
    @Persisted var cardFingerprint: String
    @Persisted var panFingerprint: String

    convenience init(token: String,
                     customer: TokenCustomer?,
                     type: String,
                     partialPan: String,
                     expireYear: String,
                     expireMonth: String,
                     cvcRequired: String,
                     bin: String,
                     funding: String,
                     countryCode: String,
                     category: String,
                     cardFingerprint: String,
                     panFingerprint: String
    ) {
        self.init()
        self.token = token
        self.customer = customer
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
}

class TokenCustomer: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var networkAddress: String
    @Persisted var countryCode: String
    convenience init(networkAddress: String, countryCode: String) {
        self.init()
        self.networkAddress = networkAddress
        self.countryCode = countryCode
    }
}
