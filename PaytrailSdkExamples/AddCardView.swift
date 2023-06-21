//
//  AddCardView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 20.6.2023.
//

import Foundation
import SwiftUI
import RealmSwift

let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")

struct AddCardView: View {
    
    @StateObject private var viewModel = ViewModel()
    @State private var savedCards: [TokenizedCard] = []
    
    var body: some View {
        VStack(spacing: 80) {
            
            // Show saved cards if any
            VStack(spacing: 24) {
                ForEach(savedCards, id: \.self) { card in
                    Text("Saved card \(card.type) with partial pan: \(card.partialPan)")
                        .bold()
                        .foregroundColor(Color.green)
                }
            }
            
            Divider()

            Button {
                // 1) Initiate add card request
                viewModel.addCardRequest = viewModel.cardApi.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/failure"))
            } label: {
                Text("Add your sweet card!")
            }
            
            Divider()
            
            Text("Card Added with partial pan: \(viewModel.tokenizedCard?.partialPan ?? "")")
                .visible(viewModel.tokenizedCard != nil)

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
        .onChange(of: viewModel.tokenizedCard) { newValue in
            guard let newValue = newValue else { return }
            viewModel.addCardToDb(newValue)
        }
        .onAppear {
            savedCards = viewModel.getSavedCards()
        }
    }
    
}

extension AddCardView {
    class ViewModel: ObservableObject, PaymentDelegate {
        let cardApi = PaytrailCardTokenAPIs()
        var realm: Realm?
        @Published var addCardRequest: URLRequest?
        @Published var tokenizedCard: TokenizedCard?
        
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
                    self.tokenizedCard = TokenizedCard(token: success.token, customer: TokenCustomer(networkAddress: success.customer?.networkAddress ?? "", countryCode: success.customer?.countryCode ?? ""), type: success.card?.type ?? "", partialPan: success.card?.partialPan ?? "", expireYear: success.card?.expireYear ?? "", expireMonth: success.card?.expireMonth ?? "", cvcRequired: success.card?.cvcRequired?.rawValue ?? "", bin: success.card?.bin ?? "", funding: success.card?.funding?.rawValue ?? "", countryCode: success.card?.countryCode ?? "", category: success.card?.category?.rawValue ?? "", cardFingerprint: success.card?.cardFingerprint ?? "", panFingerprint: success.card?.panFingerprint ?? "")
//                    self.addCardToDb(tokenizedCard)
//                    self.realm = nil
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        
        func addCardToDb(_ tokenizedCard: TokenizedCard) {
            realm = try! Realm()
            do {
                try realm!.write {
                    realm!.add(tokenizedCard)
                }
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }
        
        func getSavedCards() -> [TokenizedCard] {
            realm = try! Realm()
            let cards = realm!.objects(TokenizedCard.self)
            return cards.map { $0 }
        }
    }
}
