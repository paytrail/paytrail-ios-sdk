//
//  AddCardView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 20.6.2023.
//

import Foundation
import SwiftUI

let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")

struct AddCardView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Button {
                // 1) Initiate add card request
                viewModel.addCardRequest = viewModel.cardApi.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/failure"))
            } label: {
                Text("Add your sweet card!")
            }

        }
        .fullScreenCover(isPresented: Binding(get: { viewModel.addCardRequest != nil }, set: { _, _ in }), onDismiss: {
            viewModel.addCardRequest = nil
        }) {
            if let request = viewModel.addCardRequest {
                NavigationView {
                    // 2) Create PaymentWebView with contentType addCard once addCardRequest is made
                    PaymentWebView(request: request, delegate: viewModel, merchant: merchant, contentType: .addCard)
                        .ignoresSafeArea()
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                BackButton {
                                    viewModel.addCardRequest = nil
                                }
                            }
                        }
                }
            }
        }
    }
    
}

extension AddCardView {
    class ViewModel: ObservableObject, PaymentDelegate {
        let cardApi = PaytrailCardTokenAPIs()
        @Published var addCardRequest: URLRequest?
        
        // 3) Listen to tokenizedId change and call getToken API once tokenizedId is receiced
        func onCardTokenizedIdReceived(_ tokenizedId: String) {
            print("Checkout tokenized id received: \(tokenizedId)")
            addCardRequest = nil
            guard !tokenizedId.isEmpty else {
                print("Error, tokenizedId is empty, abort!")
                return
            }
            cardApi.getToken(of: tokenizedId, merchantId: merchant.merchantId, secret: merchant.secret) { result in
                switch result {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
}
