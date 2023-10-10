//
//  AddCardView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 20.6.2023.
//

import Foundation
import SwiftUI
import RealmSwift

@available(*, deprecated, message: "Refer to ``PaymentWallView`` instead")
struct AddCardView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var amount: String
    @Binding var status: PaymentStatus
    @StateObject private var viewModel = ViewModel()
    @State private var savedCards: [TokenizedCard] = []
    @State private var statusString: String = ""
    @State private var threeDSecureRequest: URLRequest?
    @State private var commitOnHoldAmount: String = ""
    
    private func createPayload(from token: String = "") -> PaymentRequestBody {
        return !token.isEmpty ? PaymentRequestBody(stamp: UUID().uuidString,
                                                   reference: "3759170",
                                                   amount: (Int(amount) ?? 1) * 100,
                                                   currency: .eur,
                                                   language: .fi,
                                                   items: [Item(unitPrice: (Int(amount) ?? 1) * 100, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                                   customer: Customer(email: "test.customer@example.com"),
                                                   redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                                                   callbackUrls: CallbackUrls(success: "https://qvik.com", cancel: "https://qvik.com"),
                                                   token: token) :
        PaymentRequestBody(stamp: UUID().uuidString,
                           reference: "3759170",
                           amount: (Int(amount) ?? 1) * 100,
                           currency: .eur,
                           language: .fi,
                           items: [Item(unitPrice: (Int(amount) ?? 1) * 100, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                           customer: Customer(email: "test.customer@example.com"),
                           redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                           callbackUrls: CallbackUrls(success: "https://qvik.com", cancel: "https://qvik.com"))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack() {
                    Button {
                        viewModel.clean()
                        // 1) Initiate add card request
                        viewModel.addCardRequest = PaytrailCardTokenAPIs.initiateCardTokenizationRequest(redirectUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/failure"))
                    } label: {
                        Text("Add a new card")
                            .bold()
                    }
                     
                    Spacer()
                    
                    Button {
                        viewModel.clean()
                        PaytrailCardTokenAPIs.payAndAddCard(payload: createPayload()) { result in
                            switch result {
                            case .success(let success):
                                print(success)
                                guard let urlString = success.redirectUrl else { return }
                                DispatchQueue.main.async {
                                    if let url = URL(string: urlString) {
                                        viewModel.payAndAddCardRequest = URLRequest(url: url)
                                    }
                                }
                            case .failure(let failure):
                                print(failure)
                            }
                        }
                    } label: {
                        Text("Pay and Add a new card")
                            .bold()
                    }

                }
                .frame(height: 80)
                
                Divider()
                
                // Show saved cards if any
                VStack(spacing: 24) {
                    GroupedGrid(headerTitle: "Click a saved card and pay: ") {
                        ForEach(savedCards, id: \.self) { card in
                            Button {
                                statusString = ""
                                let payload = createPayload(from: card.token)
                                let authType: PaymentAuthorizationType = card.partialPan == "0313" ? .authorizationHold : .charge
                                PaytrailCardTokenAPIs.createTokenPayment(payload: payload, transactionType: .cit, authorizationType: authType) { result in
                                    switch result {
                                    case .success(let success):
                                        statusString = "Payment success: \(success.transactionId ?? "")"
                                        DispatchQueue.main.async {
                                            if authType == .authorizationHold {
                                                viewModel.transcationOnHold = (success.transactionId!, payload)
                                                commitOnHoldAmount = String(payload.amount)
                                            } else {
                                                status = .ok
                                                mode.wrappedValue.dismiss()
                                            }
                                        }
                                        print(success)
                                    case .failure(let failure):
                                        statusString = "Payment failure!\(failure)"
                                        print(failure)
                                        if let failure = failure as? PaytrailTokenError,
                                           let threeDSecureUrl = failure.payload?.threeDSecureUrl,
                                           let url = URL(string: threeDSecureUrl) {
                                            statusString = "Redirecting to provider 3DS page to finish the payment.."
                                            let request = URLRequest(url: url)
                                            threeDSecureRequest = request
                                        }
                                    }
                                }
                            } label: {
                                Text("\(card.type) \(card.partialPan)")
                                    .bold()
                                    .foregroundColor(Color.green)
                            }

                        }
                        
                    }
                }
                
                Divider()

                VStack(spacing: 48) {
                    HStack(alignment: .center) {
                        Button {
                            
                            if let newAmount = Int64(commitOnHoldAmount) {
                                if viewModel.transcationOnHold!.payload.amount != newAmount {
                                    viewModel.updateOnHoldTransaction(with: newAmount)
                                }
                            }
                            
                            guard let transacationOnHold = viewModel.transcationOnHold else { return }
                            
                            // Client initiating commitAuthorizationHold API
                            PaytrailCardTokenAPIs.commitAuthorizationHold(transactionId: transacationOnHold.transcationId, payload: transacationOnHold.payload) { result in
                                switch result {
                                case .success(let success):
                                    DispatchQueue.main.async {
                                        viewModel.transcationOnHold = nil
                                        statusString = "Payment success: \(success.transactionId ?? "")"
                                        status = .ok
                                        mode.wrappedValue.dismiss()
                                    }

                                case .failure(let failure):
                                    statusString = "Payment failure!\(failure)"
                                    print(failure)
                                }
                            }
                        } label: {
                            Text("Commit onhold transcation")
                        }
                        
                        TextField("Amount", text: $commitOnHoldAmount)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: commitOnHoldAmount) { newText in
                                guard let amount = Int64(newText) else {
                                    commitOnHoldAmount = String(viewModel.transcationOnHold!.payload.amount)
                                    return
                                }
                                if amount > viewModel.transcationOnHold!.payload.amount {
                                    commitOnHoldAmount = String(viewModel.transcationOnHold!.payload.amount)
                                } else if amount <= 0 {
                                    commitOnHoldAmount = String(viewModel.transcationOnHold!.payload.amount)
                                }
                            }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    
                    Button {
                        guard let transacationOnHold = viewModel.transcationOnHold else { return }
                        
                        // Client initiating revertAuthorizationHold API
                        PaytrailCardTokenAPIs.revertAuthorizationHold(transactionId: transacationOnHold.transcationId) { result in
                            switch result {
                            case .success(let success):
                                DispatchQueue.main.async {
                                    viewModel.transcationOnHold = nil
                                }
                                statusString = "Reverted onhold transaction: \(success.transactionId ?? "")"
                            case .failure(let failure):
                                statusString = "Revert onhold transaction failed: --\(failure)"
                                print(failure)
                            }
                        }
                    } label: {
                        Text("Revert onhold transcation")
                    }
                    
                    Divider()
                }
                .visible(viewModel.transcationOnHold != nil)
                
                Text(statusString)
                    .visible(!statusString.isEmpty)
                
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
                    PaymentWebView(request: request, delegate: viewModel, contentType: .addCard)
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
        .fullScreenCover(isPresented: Binding(get: { viewModel.payAndAddCardRequest != nil }, set: { _, _ in }), onDismiss: {
            viewModel.payAndAddCardRequest = nil
        }) {
            if let request = viewModel.payAndAddCardRequest {
                NavigationView {
                    // Treat pay and add card as normal payment
                    PaymentWebView(request: request, delegate: viewModel, contentType: .normalPayment)
                        .ignoresSafeArea()
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                BackButton {
                                    threeDSecureRequest = nil
                                }
                            }
                        }
                }
            }
        }
        .fullScreenCover(isPresented: Binding(get: { threeDSecureRequest != nil }, set: { _, _ in }), content: {
            if let request = threeDSecureRequest {
                NavigationView {
                    PaymentWebView(request: request, delegate: viewModel)
                        .ignoresSafeArea()
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                BackButton {
                                    threeDSecureRequest = nil
                                }
                            }
                        }
                }
            }
        })
        .onChange(of: viewModel.tokenizedId, perform: { newValue in
            guard let newValue = newValue else { return }
            PaytrailCardTokenAPIs.getToken(tokenizedId: newValue) { result in
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
            guard let value = newValue else { return }
            if value {
                statusString = "Saved card successfully!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    savedCards = viewModel.savedCards
                }
            } else {
                statusString = "Saved card failed!"
            }

        })
        .onChange(of: viewModel.paymentResult, perform: { newValue in
            guard let value = newValue else { return }
            threeDSecureRequest = nil
            statusString = "Payment status: \(value.status.rawValue)"
            switch value.status {
            case .ok:
                status = .ok
                mode.wrappedValue.dismiss()
            case .fail:
                statusString = "Payment status: \(PaymentStatus.fail.rawValue)"
                if let _ = value.error {
                    // Take care of the payment error here
                }
            default:
                statusString = "Payment status: \(value.status.rawValue)"
            }
         })
        .onAppear {
            savedCards = viewModel.savedCards
        }
    }
    
}

extension AddCardView {
    class ViewModel: ObservableObject, PaymentDelegate {
        typealias TranscationOnHold = (transcationId: String, payload: PaymentRequestBody)
        var realm: Realm?
        @Published var addCardRequest: URLRequest?
        @Published var payAndAddCardRequest: URLRequest?
        @Published var tokenizedId: String?
        @Published var isCardSaved: Bool?
        @Published var paymentResult: PaymentResult?
        @Published var transcationOnHold: TranscationOnHold?
        var savedCards: [TokenizedCard] {
            getSavedCards()
        }
        
        // 3) Listen to tokenizedId change and call getToken API once tokenizedId is receiced
        func onCardTokenizedIdReceived(_ tokenizationResult: TokenizationResult) {
            print("Checkout tokenized id received: \(tokenizationResult.tokenizationId)")
            addCardRequest = nil
            guard tokenizationResult.error == nil, tokenizationResult.status == .ok else {
                print(tokenizationResult.error)
                //  Take care of the tokenization error here if any
                isCardSaved = false
                payAndAddCardRequest = nil
                return
            }
            // TODO: save tokenizedId to DB once it is confirmed to do so
            self.tokenizedId = tokenizationResult.tokenizationId
        }
        
        func onPaymentStatusChanged(_ paymentResult: PaymentResult) {
            print("payment status changed: \(paymentResult.status.rawValue)")
            self.paymentResult = paymentResult
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
            payAndAddCardRequest = nil
            tokenizedId = nil
            isCardSaved = nil
        }
        
        func updateOnHoldTransaction(with newAmount: Int64) {
            guard let payload = transcationOnHold?.payload else {
                print("Error updating on hold transaction, reason: currnt transcationOnHold is nil")
                return
            }
            
            let newPayload = PaymentRequestBody(stamp: payload.stamp,
                                                reference: payload.reference, amount: Int(newAmount), currency: payload.currency, language: payload.language, items: [Item(unitPrice: Int(newAmount), units: 1, vatPercentage: 24, productCode: "#1234")], customer: payload.customer, redirectUrls: payload.redirectUrls)
            transcationOnHold?.payload = newPayload
            
        }
    }
}
