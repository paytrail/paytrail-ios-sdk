//
//  CreatePaymentApiTestSuite.swift
//  paytrail-ios-sdkTests
//
//  Created by shiyuan on 25.5.2023.
//

import XCTest
@testable import paytrail_ios_sdk

final class CreatePaymentApiTestSuite: XCTestCase {
    
    var paymentsAPIs: PaytrailPaymentAPIs!
    var merchant: PaytrailMerchant! // Normal merchant
    var merchantSIS: PaytrailMerchant! // Shop-in-shops merchant
    var payload: PaymentRequestBody!
    var payloadInvalid: PaymentRequestBody!
    var payloadSIS: PaymentRequestBody!
    var providerImageUrl: String!
    var providerImageUrlInvalid: String!
    var providerImageUrlNotFound: String!
    var provider: PaymentMethodProvider!
    var providerInvalid: PaymentMethodProvider!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        paymentsAPIs = PaytrailPaymentAPIs()
        merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
        merchantSIS = PaytrailMerchant(merchantId: "695861", secret: "MONISAIPPUAKAUPPIAS")
        payload = PaymentRequestBody(stamp: UUID().uuidString,
                                     reference: "3759170",
                                     amount: 1525,
                                     currency: .eur,
                                     language: .fi,
                                     items: [Item(unitPrice: 1525, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                     customer: Customer(email: "test.customer@example.com"),
                                     redirectUrls: CallbackUrls(success: "google.com", cancel: "google.com"),
                                     callbackUrls: nil)
        
        payloadSIS = PaymentRequestBody(stamp: UUID().uuidString,
                                        reference: "3759170",
                                        amount: 1525,
                                        currency: .eur,
                                        language: .fi,
                                        items: [Item(unitPrice: 1525, units: 1, vatPercentage: 24, productCode: "#1234", merchant: "695874", stamp: UUID().uuidString, reference: "3759170")],
                                        customer: Customer(email: "test.customer@example.com"),
                                        redirectUrls: CallbackUrls(success: "google.com", cancel: "google.com"),
                                        callbackUrls: nil)
        
        payloadInvalid = PaymentRequestBody(stamp: UUID().uuidString,
                                            reference: "3759170",
                                            amount: 1525,
                                            currency: .eur,
                                            language: .fi,
                                            items: [Item(unitPrice: 1525, units: 1, vatPercentage: 24, productCode: "#1234", deliveryDate: "2018-09-012")], // invalid
                                            customer: Customer(email: "test.customer@example.com"),
                                            redirectUrls: CallbackUrls(success: "google.com", cancel: "google.com"),
                                            callbackUrls: nil)
        
        providerImageUrl = "https://resources.paytrail.com/images/payment-method-logos/alandsbanken.png"
        providerImageUrlInvalid = "payment-method-logos/aldsbanken.png"
        providerImageUrlNotFound = "https://resources.paytrail.com/images/payment-method-logos/asbanken.png"
        
        if let providerData = try? loadProviderJSONData(from: "Provider") {
            provider = try? jsonDecode(of: PaymentMethodProvider.self, data: providerData)
        }
        
        if let providerData = try? loadProviderJSONData(from: "ProviderInvalid") {
            providerInvalid = try? jsonDecode(of: PaymentMethodProvider.self, data: providerData)
        }
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    /// Test Success 200 - Payment create success with normal merchant credentials
    func testCreatePaymentSuccess() async {
        let result = await createPaymentsAsync(merchant.merchantId, secret: merchant.secret, payload: payload)
        switch result {
        case .success(let success):
            XCTAssert(success.transactionId != nil && success.providers != nil)
        case .failure(let failure):
            XCTFail("Create payment failed: \(failure.localizedDescription)")
        }
    }
    
    /// Test Success 200 - Payment create with Shop-in-Shops merchant credentials
    func testCreatePaymentSisSuccess() async {
        let result = await createPaymentsAsync(merchantSIS.merchantId, secret: merchantSIS.secret, payload: payloadSIS)
        switch result {
        case .success(let success):
            XCTAssert(success.transactionId != nil && success.providers != nil)
        case .failure(let failure):
            print(failure)
            XCTFail("Create payment failed: \(failure.localizedDescription)")
        }
    }
    
    /// Test Auth Error 401 - Authentication error with invalid merchant
    func testCreatePaymentMerchantFailure() async {
        let result = await createPaymentsAsync("123", secret: "456", payload: payload)
        switch result {
        case .success(let success):
            XCTAssert(success.transactionId == nil && success.providers == nil)
        case .failure(let failure as NSError):
            print(failure)
            let message = (failure.userInfo["info"] as? PaymentErrorResponse)?.message ?? ""
            XCTAssert(failure.code == 401 && message.lowercased().contains("invalid merchant"))
        }
    }
    
    
    /// Test Validation Error 400 - Payload validation failure against the schema
    func testCreatePaymentInvalidPayloadFailure() async {
        let result = await createPaymentsAsync(merchant.merchantId, secret: merchant.secret, payload: payloadInvalid)
        switch result {
        case .success(let success):
            XCTAssert(success.transactionId == nil && success.providers == nil)
        case .failure(let failure as NSError):
            print(failure)
            let message = (failure.userInfo["info"] as? PaymentErrorResponse)?.message ?? ""
            XCTAssert(failure.code == 400 && message.lowercased().contains("validation failed"))
        }
    }
    
    
    /// Test renderPaymentProviderImage API success with a valid url
    func testRenderPaymentProviderImageSuccess() async {
        let result = await renderPaymentProviderImageAsync(providerImageUrl)
        switch result {
        case .success(let success):
            XCTAssertFalse(success.size.equalTo(CGSize.zero))
        case .failure(let failure):
            XCTFail("Render provider image failed: \(failure.localizedDescription)")
        }
    }
    
    /// Test renderPaymentProviderImage API with an invalid url
    func testRenderPaymentProviderImageFailure() async {
        let result = await renderPaymentProviderImageAsync(providerImageUrlInvalid)
        switch result {
        case .success(let success):
            XCTAssertTrue(success.size.equalTo(CGSize.zero))
        case .failure(let failure as NSError):
            print(failure)
            XCTAssert(failure.code == -1002, "Unsupported URL")
        }
    }
    
    /// Test renderPaymentProviderImage API with an inaccessible url
    func testRenderPaymentProviderImageDecodeFailure() async {
        let result = await renderPaymentProviderImageAsync(providerImageUrlNotFound)
        switch result {
        case .success(let success):
            XCTAssertTrue(success.size.equalTo(CGSize.zero))
        case .failure(let failure as NSError):
            print(failure)
            XCTAssert(failure.code == 403, "Invalid image json")
        }
    }
    
    /// Test initiatePaymentRequest API with a valid URLRequest return
    func testInitiatePaymentRequestValid() {
        guard let provider = provider else {
            XCTFail("Provider is nil")
            return
        }

        let request = paymentsAPIs.initiatePaymentRequest(from: provider)
        XCTAssert(request?.url != nil && request?.httpBody != nil, "Valid payment request")
    }
    
    /// Test initiatePaymentRequest API with an invalid URLRequest return when provider data is invalid
    func testInitiatePaymentRequestInvalid() {
        guard let provider = providerInvalid else {
            XCTFail("Provider is nil")
            return
        }
        
        let request = paymentsAPIs.initiatePaymentRequest(from: provider)
        XCTAssert(request == nil, "Request is nil due to invalid provider data")
    }
    
    private func createPaymentsAsync(_ merchantId: String, secret: String, payload: PaymentRequestBody) async -> Result<PaymentRequestResponse, Error> {
        await withCheckedContinuation({ continuation in
            paymentsAPIs.createPayment(of: merchantId, secret: secret, payload: payload) { result in
                continuation.resume(returning: result)
            }
        })
    }
    
    private func renderPaymentProviderImageAsync(_ url: String) async -> Result<UIImage, Error> {
        await withCheckedContinuation({ continuation in
            paymentsAPIs.renderPaymentProviderImage(by: url) { result in
                continuation.resume(returning: result)
            }
        })
    }
    
    private func loadProviderJSONData(from file: String) throws -> Data {
        let filePath = Bundle(for: CreatePaymentApiTestSuite.self).path(forResource: file,
                                                                     ofType: "json")!
        let fileURL = URL(fileURLWithPath: filePath)
        return try Data(contentsOf: fileURL)
    }

}
