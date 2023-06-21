//
//  AddCardView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 20.6.2023.
//

import Foundation
import SwiftUI

struct AddCardView: View {
    
    private let cardApi = PaytrailCardTokenAPIs()
    private let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
    
    @State private var addCardRequest: URLRequest?
    
    var body: some View {
        VStack {
            Button {
                addCardRequest = cardApi.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/failure"))
            } label: {
                Text("Add your sweet card!")
            }

        }
        .fullScreenCover(isPresented: Binding(get: { addCardRequest != nil }, set: { _, _ in }), onDismiss: {
            addCardRequest = nil
        }) {
            if let request = addCardRequest {
                NavigationView {
                    // 2) Load PaymentWebView by the URLRequest and pass a PaymentDelegate for handling payment callbacks
                    PaymentWebView(request: request, delegate: nil, merchant: merchant)
                        .ignoresSafeArea()
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                BackButton {
                                    addCardRequest = nil
                                }
                            }
                        }
                }
            }
        }
    }
    
}
