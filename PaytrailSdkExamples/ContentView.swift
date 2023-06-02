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
            
            let headers = [
                "checkout-account": "375917",
                "checkout-algorithm": "sha256",
                "checkout-method": "POST",
                "checkout-nonce": "564635208570151",
                "checkout-timestamp": "2018-07-06T10:01:31.904Z"
                ]
            
            let payload = PaymentRequestBody(stamp: "29858472969",
                                             reference: "3759170",
                                             amount: 1525,
                                             currency: "EUR",
                                             language: "FI",
                                             items: [Item(unitPrice: 1525, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                             customer: Customer(email: "test.customer@example.com"),
                                             redirectUrls: RedirectUrls(success: "google.com", cancel: "google.com"),
                                             callbackUrls: nil)
            PaytrailPaymentAPIs().createPayment(of: "375917", secret: "SAIPPUAKAUPPIAS", headers: headers, payload: payload, completion: { result in
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
