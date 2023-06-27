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
    
    let cardApi = PaytrailCardTokenAPIs()
    @StateObject private var viewModel = ViewModel()
    @State private var savedCards: [TokenizedCard] = []
    @State private var statusString: String = ""
    
    private var autoPayload: PaymentRequestBody {
        let token =  savedCards.first?.token ?? ""
        let payload = PaymentRequestBody(stamp: UUID().uuidString,
                                         reference: "3759170",
                                         amount: 1999,
                                         currency: .eur,
                                         language: .fi,
                                         items: [Item(unitPrice: 1999, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                         customer: Customer(email: "test.customer@example.com"),
                                         redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                                         callbackUrls: CallbackUrls(success: "https://qvik.com", cancel: "https://qvik.com"),
                                         token: token)
        return payload
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 80) {
                
                // Show saved cards if any
                VStack(spacing: 24) {
                    GroupedGrid(headerTitle: "Saved Cards: ") {
                        ForEach(savedCards, id: \.self) { card in
                            Text("\(card.type) \(card.partialPan)")
                                .bold()
                                .foregroundColor(Color.green)
                        }
                        
                    }
                }
  
                Divider()
                
                Button {
                    viewModel.clean()
                    // 1) Initiate add card request
                    viewModel.addCardRequest = cardApi.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/failure"))
                } label: {
                    Text("Add your sweet card!")
                }
                
                Divider()

                Button {
                    statusString = ""
                    cardApi.createTokenPayment(of: merchant.merchantId, secret: merchant.secret, payload: autoPayload, transactionType: .cit, authorizationType: .charge) { result in
                        switch result {
                        case .success(let success):
                            statusString = "Payment success: \(success.transactionId ?? "")"
                            print(success)
                        case .failure(let failure):
                            statusString = "Payment failure!\(failure)"
                            print(failure)
                        }
                    }
                } label: {
                    Text("Pay with saved card!")
                }
                
                Divider()
                
                Text(statusString)
                    .visible(!statusString.isEmpty)
                
                Text("Card saved successfully!")
                    .foregroundColor(Color.green)
                    .visible(viewModel.isCardSaved == true)
                
                Text("Card saved unsuccessfully")
                    .foregroundColor(Color.red)
                    .visible(viewModel.isCardSaved == false)
                
            }
            
        }
        .frame(
          minWidth: 0,
          maxWidth: .infinity,
          minHeight: 0,
          maxHeight: .infinity,
          alignment: .topLeading
        )
        .padding()
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
        .onChange(of: viewModel.tokenizedId, perform: { newValue in
            guard let newValue = newValue else { return }
            cardApi.getToken(of: newValue, merchantId: merchant.merchantId, secret: merchant.secret) { result in
                switch result {
                case .success(let success):
                    print(success)
                    let tokenizedCard = TokenizedCard(token: success.token, customer: TokenCustomer(networkAddress: success.customer?.networkAddress ?? "", countryCode: success.customer?.countryCode ?? ""), type: success.card?.type ?? "", partialPan: success.card?.partialPan ?? "", expireYear: success.card?.expireYear ?? "", expireMonth: success.card?.expireMonth ?? "", cvcRequired: success.card?.cvcRequired?.rawValue ?? "", bin: success.card?.bin ?? "", funding: success.card?.funding?.rawValue ?? "", countryCode: success.card?.countryCode ?? "", category: success.card?.category?.rawValue ?? "", cardFingerprint: success.card?.cardFingerprint ?? "", panFingerprint: success.card?.panFingerprint ?? "")
                    viewModel.addCardToDb(tokenizedCard)
                case .failure(let failure):
                    print(failure)
                    viewModel.isCardSaved = false
                }
            }
        })
        .onChange(of: viewModel.isCardSaved, perform: { newValue in
            guard let value = newValue, value else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                savedCards = viewModel.savedCards
            }
        })
        .onAppear {
            savedCards = viewModel.savedCards
        }
    }
    
}

extension AddCardView {
    class ViewModel: ObservableObject, PaymentDelegate {
        var realm: Realm?
        @Published var addCardRequest: URLRequest?
        @Published var tokenizedId: String?
        @Published var isCardSaved: Bool?
        var savedCards: [TokenizedCard] {
            getSavedCards()
        }
        
        // 3) Listen to tokenizedId change and call getToken API once tokenizedId is receiced
        func onCardTokenizedIdReceived(_ tokenizationResult: TokenizationResult) {
            print("Checkout tokenized id received: \(tokenizationResult.tokenizationId)")
            addCardRequest = nil
            guard tokenizationResult.errorMessage.isEmpty, tokenizationResult.status == .ok else {
                print(tokenizationResult.errorMessage)
                isCardSaved = false
                return
            }
            // TODO: save tokenizedId to DB once it is confirmed to do so
            self.tokenizedId = tokenizationResult.tokenizationId
        }
        
        func addCardToDb(_ tokenizedCard: TokenizedCard) {
            realm = try! Realm()
            do {
                try realm!.write {
                    realm!.add(tokenizedCard)
                }
            } catch let error as NSError {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.isCardSaved = false
                }
            }
            DispatchQueue.main.async {
                self.isCardSaved = true
            }
        }
        
        func getSavedCards() -> [TokenizedCard] {
            realm = try! Realm()
            let cards = realm!.objects(TokenizedCard.self)
            return cards.map { $0 }
        }
        
        func clean() {
            addCardRequest = nil
            tokenizedId = nil
            isCardSaved = nil
        }
    }
}
