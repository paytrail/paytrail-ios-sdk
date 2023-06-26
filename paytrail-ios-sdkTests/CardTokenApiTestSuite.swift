//
//  CardTokenApiTestSuite.swift
//  paytrail-ios-sdkTests
//
//  Created by shiyuan on 26.6.2023.
//

import XCTest
import paytrail_ios_sdk

final class CardTokenApiTestSuite: XCTestCase {
    
    var cardTokenApis: PaytrailCardTokenAPIs!
    var merchant: PaytrailMerchant!

    override func setUpWithError() throws {
        cardTokenApis = PaytrailCardTokenAPIs()
        merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
            
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitiateCardTokenizationRequestSuccess() {
        let result = cardTokenApis.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "https://paytrail.com/success", cancel: "https://paytrail.com/cancel"))
        XCTAssert(result != nil && result?.httpBody != nil)
    }
    
    func testInitiateCardTokenizationRequestFail() {
        let result = cardTokenApis.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "paytrail.com/success", cancel: "paytrail.com/cancel"))
        XCTAssert(result == nil, "Error, invalid redicrect urls")
    }

}
