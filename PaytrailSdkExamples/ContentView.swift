//
//  ContentView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI
import paytrail_ios_sdk

struct ContentView: View {
    
    @State private var contentText: String = ""
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(contentText)
        }
        .padding()
        .onAppear {
            
            let payload = PaymentRequestBody(stamp: UUID().uuidString,
                                             reference: "3759170",
                                             amount: 1525,
                                             currency: "EUR",
                                             language: "FI",
                                             items: [Item(unitPrice: 1525, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                             customer: Customer(email: "test.customer@example.com"),
                                             redirectUrls: CallbackUrls(success: "google.com", cancel: "google.com"),
                                             callbackUrls: nil)
            PaytrailPaymentAPIs().createPayment(of: "375917", secret: "SAIPPUAKAUPPIAS", payload: payload, completion: { result in
                switch result {
                case .success(let data):
                    //                    print(data)
                    contentText = "SUCCESS: \((data as PaymentRequestResponse).transactionId ?? "Unknown transactionId but success")"
                case .failure(let error as NSError):
                    print(error)
                    contentText = error.userInfo.description
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
