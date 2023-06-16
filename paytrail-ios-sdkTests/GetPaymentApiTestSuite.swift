//
//  GetPaymentApiTestSuite.swift
//  paytrail-ios-sdkTests
//
//  Created by shiyuan on 16.6.2023.
//

import XCTest
@testable import paytrail_ios_sdk

final class GetPaymentApiTestSuite: XCTestCase {
    
    var paymentsAPIs: PaytrailPaymentAPIs!
    var merchant: PaytrailMerchant!
    var transactionId: String!
    var transactionIdInvalid: String!

    override func setUpWithError() throws {
        paymentsAPIs = PaytrailPaymentAPIs()
        merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
        transactionId = "cfaa43a2-0c4e-11ee-829b-a75b998e8f55"
        transactionIdInvalid = "cac671c0-0b78-11ee-aa4c-9beeff41cc48"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// Test getPayment API success with a valid transaction id
    func testGetPaymentSuccess() async {
        let result = await getPaymentAsync(transactionId)
        switch result {
        case .success(let success):
            XCTAssert(success.transactionId != nil && success.provider != nil)
        case .failure(let failure):
            print(failure)
            XCTFail("Get payment failed: \(failure.localizedDescription)")
        }
    }
    
    /// Test getPaymnet API failure with an invalid transaction id
    func testGetPaymentFailure() async {
        let result = await getPaymentAsync(transactionIdInvalid)
        switch result {
        case .success(let success):
            XCTAssert(success.transactionId == nil && success.provider == nil)
        case .failure(let failure as NSError):
            print(failure)
            XCTAssert(failure.code == 404, "Invalid transaction id")
        }
    }
    
    private func getPaymentAsync(_ transactionId: String) async -> Result<Payment, Error> {
        await withCheckedContinuation({ continuation in
            paymentsAPIs.getPayment(of: merchant.merchantId, secret: merchant.secret, transactionId: transactionId) { result in
                continuation.resume(returning: result)
            }
        })
    }


}
