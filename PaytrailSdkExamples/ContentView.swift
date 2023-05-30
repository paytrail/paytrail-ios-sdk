//
//  ContentView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI
import paytrail_ios_sdk

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            PaytrailPaymentAPIs().createPayment(of: "375917", secret: "SAIPPUAKAUPPIAS", headers: [
            "checkout-account" : "375917",
            "checkout-algorithm": "sha256",
            "checkout-method": "POST",
            "checkout-nonce": "564635208570151",
            "checkout-timestamp": "2018-07-06T10:01:31.904Z",
            "signature": "3708f6497ae7cc55a2e6009fc90aa10c3ad0ef125260ee91b19168750f6d74f6"
            ], payload: PaymentRequestBody(stamp: "unique-identifier-for-merchant",
                                           reference: "3759170",
                                           amount: 1525,
                                           currency: "EUR",
                                           language: "FI",
                                           items: [Item(unitPrice: 1525, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-01")],
                                           customer: Customer(email: "test.customer@example.com"),
                                           redirectUrls: RedirectUrls(success: "https://ecom.example.com/cart/success", cancel: "https://ecom.example.com/cart/cancel"),
                                           callbackUrls: nil), completion: { result in
                                                print(result)
                                           })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
