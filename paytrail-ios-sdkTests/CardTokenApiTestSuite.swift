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
    var tokenizedIdThreeDS: String!
    var transactionType: PaytrailCardTokenAPIs.PaymentTransactionType!
    var authorizationType: PaytrailCardTokenAPIs.PaymentAuthorizationType!
    var committedTransactionId: String!
    var revertedTransactionId: String!
    

    override func setUpWithError() throws {
        cardTokenApis = PaytrailCardTokenAPIs()
        merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
        tokenizedId = "96f32ab1-8c1f-42f1-9c11-cce40cb648ac"
        tokenizedIdThreeDS = "17b8c4a0-9a2d-4bdd-8eb3-f2deacb96292"
        transactionType = .cit
        authorizationType = .charge
        committedTransactionId = "526b728c-1a66-11ee-bdc7-f3592b2cbca7"
        revertedTransactionId = "dd486ff2-1a6d-11ee-8b59-c397ccfafde9"
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
    
    
    /// Test createTokenPayment success case with a valid tokenized Id
    func testCreateTokenPaymentChargeSuccess() async {
        let tokenResult = await getTokenAsync(tokenizedId, merchantId: merchant.merchantId, secret: merchant.secret)
        switch tokenResult {
        case .success(let success):
            let payload = createPaymentPayload(with: success.token)
            let result = await createTokenPaymentAsync(merchant.merchantId, secret: merchant.secret, payload: payload, transactionType: transactionType, authorizationType: authorizationType)
            switch result {
            case .success(let success):
                XCTAssert(success.transactionId != nil, "Success token payment returning a transaction Id")
            case .failure(let failure):
                print(failure)
                XCTFail("Create token payment failure: \(failure)")
            }
        case .failure(let failure):
            print(failure)
            XCTFail("Failing to create token payment due to invalid tokenized id")
        }

    }
    
    /// Test createTokenPayment failure case with an invalid tokenized Id
    func testCreateTokenPaymentChargeFailure() async {
        let invalidPayload = createPaymentPayload(with: "")
        let result = await createTokenPaymentAsync(merchant.merchantId, secret: merchant.secret, payload: invalidPayload, transactionType: transactionType, authorizationType: authorizationType)
        switch result {
        case .success(_):
            XCTFail("Invalid create token payment success with an invalid payload")
        case .failure(let failure):
            print(failure)
            let paymentError = failure as? PaytrailPaymentError
            XCTAssert(paymentError?.type == .createTokenPayment &&  paymentError?.code == 400)
        }
    }
    
    /// Test createTokenPayment failure 403 with a soft 3DS decline
    func testCreateTokenPaymentChargeThreeDs403() async {
        let tokenResult = await getTokenAsync(tokenizedIdThreeDS, merchantId: merchant.merchantId, secret: merchant.secret)
        switch tokenResult {
        case .success(let success):
            let payload = createPaymentPayload(with: success.token)
            let result = await createTokenPaymentAsync(merchant.merchantId, secret: merchant.secret, payload: payload, transactionType: transactionType, authorizationType: authorizationType)
            switch result {
            case .success(_):
                XCTFail("Invalid create token payment success with a 3DS token")
            case .failure(let failure):
                print(failure)
                let tokenError = failure as? PaytrailTokenError
                let payload = tokenError?.payload as? TokenPaymentThreeDsReponse
                XCTAssert(tokenError?.code == 403 && payload?.transactionId != nil && payload?.threeDSecureUrl != nil)
            }
        case .failure(let failure):
            print(failure)
            XCTFail("Failing to create token payment due to invalid tokenized id")
        }
    }
    
    
    /// Test createTokenPayment authorizationHold sucess case
    func testCreateTokenPaymentAuthOnholdSuccess() async {
        let tokenResult = await getTokenAsync(tokenizedId, merchantId: merchant.merchantId, secret: merchant.secret)
        switch tokenResult {
        case .success(let success):
            let payload = createPaymentPayload(with: success.token)
            let result = await createTokenPaymentAsync(merchant.merchantId, secret: merchant.secret, payload: payload, transactionType: .mit, authorizationType: .authorizationHold)
            switch result {
            case .success(let success):
                print(success)
                XCTAssert(success.transactionId != nil, "Success token payment returning a transaction Id")
            case .failure(let failure):
                print(failure)
                XCTFail("Create token payment failure: \(failure)")
            }
        case .failure(let failure):
            print(failure)
            XCTFail("Failing to create token payment due to invalid tokenized id")
        }
    }
    
    
    /// Test commitAuthorizationHold succcess case when an unpaid on-hold transaction is committed
    func testCommitAuthorizationHoldSuccess() async {
        let tokenResult = await getTokenAsync(tokenizedId, merchantId: merchant.merchantId, secret: merchant.secret)
        
        if case .success(let success) = tokenResult {
            let payload = createPaymentPayload(with: success.token)
            let paymentResult = await createTokenPaymentAsync(merchant.merchantId, secret: merchant.secret, payload: payload, transactionType: .mit, authorizationType: .authorizationHold)
            
            if case .success(let success) = paymentResult {
                let result = await commitAuthorizationHoldAsync(merchant.merchantId, secret: merchant.secret, transactionId: success.transactionId ?? "", payload: payload)
                switch result {
                case .success(let commitSuccess):
                    print(commitSuccess)
                    XCTAssert(commitSuccess.transactionId != nil && commitSuccess.transactionId == success.transactionId, "Commit onhold token payment successfully")
                case .failure(let failure):
                    print(failure)
                    XCTFail("Failing to create token payment due to invalid tokenized id")
                }
            }
        }
    }
    
    
    /// Test commitAuthorizationHold failure case with a revertedTransactionId
    func testCommitAuthorizationHoldFailure() async {
        let tokenResult = await getTokenAsync(tokenizedId, merchantId: merchant.merchantId, secret: merchant.secret)
        if case .success(let success) = tokenResult {
            let payload = createPaymentPayload(with: success.token)
            let result = await commitAuthorizationHoldAsync(merchant.merchantId, secret: merchant.secret, transactionId: revertedTransactionId, payload: payload)
            switch result {
            case .success(let success):
                print(success)
                XCTFail("Invalid success due to invalid transaction Id")
            case .failure(let failure):
                print(failure)
                let error = failure as? any PaytrailError
                XCTAssert(error?.code == 400, "Trade is already cancelled, cannot commit.")
            }
        }
    }
    
    
    /// Test revertAuthorizationHold success case when an unpaid on-hold transaction is reverted
    func testRevertAuthorizationHoldSuccess() async {
        
        let tokenResult = await getTokenAsync(tokenizedId, merchantId: merchant.merchantId, secret: merchant.secret)
        
        if case .success(let success) = tokenResult {
            let payload = createPaymentPayload(with: success.token)
            let paymentResult = await createTokenPaymentAsync(merchant.merchantId, secret: merchant.secret, payload: payload, transactionType: .mit, authorizationType: .authorizationHold)
            if case .success(let success) = paymentResult {
                
                let result = await revertAuthorizationHoldAsync(merchant.merchantId, secret: merchant.secret, transactionId: success.transactionId ?? "")
                switch result {
                case .success(let commitSuccess):
                    print(commitSuccess)
                    XCTAssert(commitSuccess.transactionId != nil && commitSuccess.transactionId == success.transactionId, "Revert onhold token payment successfully")
                case .failure(let failure):
                    print(failure)
                    XCTFail("Failing to revert an onhold transaction")
                }
            }
        }
    }
    
    
    /// Test revertAuthorizationHold failure case when the transaction has already been committed/paid
    func testRevertAuthorizationHoldFailure() async {
        let result = await revertAuthorizationHoldAsync(merchant.merchantId, secret: merchant.secret, transactionId: committedTransactionId)
        switch result {
        case .success(let success):
            print(success)
            XCTAssert(success.transactionId == committedTransactionId)
            XCTFail("Invalid success due to invalid (paid) transaction Id")
        case .failure(let failure):
            print(failure)
            let error = failure as? PaytrailPaymentError
            XCTAssert(error?.code == 400, "Trade is already paid, cannot cancel.")
        }
    }
    
    
    // MARK: - Private funcs
    
    private func getTokenAsync(_ tokenizedId: String, merchantId: String, secret: String) async -> Result<TokenizationRequestResponse, Error> {
        await withCheckedContinuation({ continuation in
            cardTokenApis.getToken(of: tokenizedId, merchantId: merchantId, secret: secret) { result in
                continuation.resume(returning: result)
            }
        })
    }
    
    private func createTokenPaymentAsync(_ merchantId: String, secret: String, payload: PaymentRequestBody, transactionType: PaytrailCardTokenAPIs.PaymentTransactionType, authorizationType: PaytrailCardTokenAPIs.PaymentAuthorizationType) async -> Result<TokenPaymentRequestResponse, Error> {
        await withCheckedContinuation({ continuation in
            cardTokenApis.createTokenPayment(of: merchantId, secret: secret, payload: payload, transactionType: transactionType, authorizationType: authorizationType) { result in
                continuation.resume(returning: result)
            }
        })
    }
    
    private func updateTransactionAndAuthType(_ transactionType: PaytrailCardTokenAPIs.PaymentTransactionType = .mit, authType: PaytrailCardTokenAPIs.PaymentAuthorizationType) {
        self.transactionType = transactionType
        self.authorizationType = authType
    }
    
    private func createPaymentPayload(with token: String) -> PaymentRequestBody {
        PaymentRequestBody(stamp: UUID().uuidString,
                                                 reference: "3759170",
                                                 amount: 2200,
                                                 currency: .eur,
                                                 language: .fi,
                                                 items: [Item(unitPrice: 2200, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                                 customer: Customer(email: "test.customer@example.com"),
                                                 redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                                                 callbackUrls: CallbackUrls(success: "https://qvik.com", cancel: "https://qvik.com"),
                                         token: token)
    }
    
    
    private func commitAuthorizationHoldAsync(_ merchantId: String, secret: String, transactionId: String, payload: PaymentRequestBody) async -> Result<TokenPaymentRequestResponse, Error> {
        await withCheckedContinuation({ continuation in
            cardTokenApis.commitAuthorizationHold(of: merchantId, secret: secret, transactionId: transactionId, payload: payload) { result in
                continuation.resume(returning: result)
            }
        })
    }
    
    private func revertAuthorizationHoldAsync(_ merchantId: String, secret: String, transactionId: String) async -> Result<TokenPaymentRequestResponse, Error> {
        await withCheckedContinuation({ continuation in
            cardTokenApis.revertAuthorizationHold(of: merchantId, secret: secret, transactionId: transactionId) { result in
                continuation.resume(returning: result)
            }
        })
    }

}
