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
    var tokenizedId: String!

    override func setUpWithError() throws {
        cardTokenApis = PaytrailCardTokenAPIs()
        merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
        tokenizedId = "96f32ab1-8c1f-42f1-9c11-cce40cb648ac"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /// Test initiateCardTokenizationRequest API sucess with a valid redirectUrls
    func testInitiateCardTokenizationRequestSuccess() {
        let result = cardTokenApis.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "https://paytrail.com/success", cancel: "https://paytrail.com/cancel"))
        XCTAssert(result != nil && result?.httpBody != nil)
    }
    
    /// Test initiateCardTokenizationRequest API failure with an invalid redirectUrls
    func testInitiateCardTokenizationRequestFailure() {
        let result = cardTokenApis.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "paytrail.com/success", cancel: "paytrail.com/cancel"))
        XCTAssert(result == nil, "Error, invalid redicrect urls")
    }
    
    /// Test getToken API success with a valid tokenizedId
    func testGetTokenSuccess() async {
        let result = await getTokenAsync(tokenizedId, merchantId: merchant.merchantId, secret: merchant.secret)
        switch result {
        case .success(let success):
            XCTAssert(success.customer != nil && success.card != nil, "Get token success:\(success.token)")
        case .failure(let failure as NSError):
            print(failure)
            XCTFail("Failing due to \(failure.description)")
        }
    }
    
    /// Test getToken API failure with an invalid tokenizedId
    func testGetTokenFailure() async {
        let result = await getTokenAsync("1234567", merchantId: merchant.merchantId, secret: merchant.secret)
        switch result {
        case .success(_):
            XCTFail("Failing due to invalid tokenized id")
        case .failure(let failure as NSError):
            print(failure)
            XCTAssert(failure.code == 400, "Invalid tokenized id")
        }
    }
    
    private func getTokenAsync(_ tokenizedId: String, merchantId: String, secret: String) async -> Result<TokenizationRequestResponse, Error> {
        await withCheckedContinuation({ continuation in
            cardTokenApis.getToken(of: tokenizedId, merchantId: merchantId, secret: secret) { result in
                continuation.resume(returning: result)
            }
        })
    }

}
