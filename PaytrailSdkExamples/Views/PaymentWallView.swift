//
//  ContentView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI
import RealmSwift

struct PaymentWallView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Binding var items: [ShoppingItem]
    @Binding var customer: Customer?
    @Binding var fullAddress: Address?
    @Binding var isShowing: Bool
    
    var amount: Int {
        productItems.map { $0.unitPrice * $0.units }.reduce(0,+)
    }
    
    var productItems: [Item] {
        items.map { $0.toProductItem(shoppingItem: $0) }
    }
    
    @State private var status: PaymentStatus = .new
    //    @State private var contentText: String = ""
    @State private var providers: [PaymentMethodProvider] = []
    @State private var groups: [PaymentMethodGroup] = []
    @State private var providerImages: [UIImage] = []
    @StateObject var viewModel = ViewModel()
    private let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
    @State private var showPaymentResultView: Bool = false
    @State private var showProgressView: Bool = false
    
    @State var savedCards: [TokenizedCard] = []
    
    private func createPayload(from token: String = "") -> PaymentRequestBody {
        return !token.isEmpty ? PaymentRequestBody(stamp: UUID().uuidString,
                                                   reference: "3759170",
                                                   amount: amount,
                                                   currency: .eur,
                                                   language: .en,
                                                   items: productItems,
                                                   customer: customer!,
                                                   redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                                                   callbackUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/fail"),
                                                   deliveryAddress: fullAddress,
                                                   invoicingAddress: fullAddress,
                                                   token: token) :
        PaymentRequestBody(stamp: UUID().uuidString,
                                         reference: "3759170",
                                         amount: amount,
                                         currency: .eur,
                                         language: .en,
                                         items: productItems,
                                         customer: customer!,
                                         redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                                         callbackUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/fail"),
                                         deliveryAddress: fullAddress,
                                         invoicingAddress: fullAddress)
    }
    
    var body: some View {
        AppBackgroundView {
            ZStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    HeaderView(itemCount: items.count)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .background(Color.white)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            VStack {
                                CartSummaryView(items: items)
                                    .padding(.horizontal, 24)
                                    .padding(.bottom, 16)
                            }
                            .background(Color.white)
                            .padding(.horizontal, -24)
                            
                            Text("**Pay with saved cards**")
                                .font(.system(size: 24))
                                .padding(.bottom, 24)
                                .padding(.top, 24)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.black)
                            
                            GroupedGrid(headerTitle: "") {
                                ForEach(savedCards, id: \.self) { card in
                                    PaymentCardView(card: card) {
                                        showProgressView = true
                                        let payload = createPayload(from: card.token)
                                        let authType: PaymentAuthorizationType = .charge
                                        PaytrailCardTokenAPIs.createTokenPayment(of: merchant.merchantId, secret: merchant.secret, payload: payload, transactionType: .cit, authorizationType: authType) { result in
                                            showProgressView = false
                                            switch result {
                                            case .success(_):
                                                DispatchQueue.main.async {
                                                    if authType == .authorizationHold {
                                                        // Handle payment on-hold
                                                    } else {
                                                        status = .ok
                                                        showPaymentResultView = true
                                                    }
                                                }
                                            case .failure(let failure):
                                                print(failure)
                                                if let failure = failure as? PaytrailTokenError,
                                                   let threeDSecureUrl = failure.payload?.threeDSecureUrl,
                                                   let url = URL(string: threeDSecureUrl) {
                                                    let request = URLRequest(url: url)
                                                    DispatchQueue.main.async {
                                                        viewModel.threeDSecureRequest = request
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                            TextButton(text: "Add card", theme: .fill()) {
                                viewModel.clean()
                                // 1) Initiate add card request
                                viewModel.addCardRequest = PaytrailCardTokenAPIs.initiateCardTokenizationRequest(of: merchant.merchantId, secret: merchant.secret, redirectUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/failure"))
                            }
                            .padding(.top, 24)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("**Pay with a payment method**")
                                .font(.system(size: 24))
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.black)
                            
                            Text("By selecting a payment method, you agree to our payment service terms & conditions.")
                                .font(.system(size: 12))
                                .foregroundColor(Color.init("textGray"))
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                PaymentProvidersView(themes: PaytrailThemes(viewMode: .normal(), itemSize: PaytrailThemes.ItemSize.large),providers: $providers, groups: groups, paymentRequest: Binding(get: { viewModel.currentPaymentRequest }, set: { request in
                                    viewModel.currentPaymentRequest = request
                                }))
                            }
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 0,
                                maxHeight: .infinity,
                                alignment: .topLeading
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 12)
                            .fullScreenCover(isPresented: Binding(get: { viewModel.currentPaymentRequest != nil }, set: { _, _ in }), onDismiss: {
                                viewModel.currentPaymentRequest = nil
                            }) {
                                if let request = viewModel.currentPaymentRequest {
                                    NavigationView {
                                        // 2) Load PaymentWebView by the URLRequest and pass a PaymentDelegate for handling payment callbacks
                                        PaymentWebView(request: request, delegate: viewModel, merchant: merchant)
                                            .ignoresSafeArea()
                                            .navigationBarTitleDisplayMode(.inline)
                                            .toolbar {
                                                ToolbarItem(placement: .navigationBarLeading) {
                                                    BackButton {
                                                        viewModel.currentPaymentRequest = nil
                                                        viewModel.paymentResult = nil
                                                    }
                                                }
                                            }
                                    }
                                }
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
                        .fullScreenCover(isPresented: Binding(get: { viewModel.threeDSecureRequest != nil }, set: { _, _ in }), content: {
                            if let request = viewModel.threeDSecureRequest {
                                NavigationView {
                                    PaymentWebView(request: request, delegate: viewModel, merchant: merchant)
                                        .ignoresSafeArea()
                                        .navigationBarTitleDisplayMode(.inline)
                                        .toolbar {
                                            ToolbarItem(placement: .navigationBarLeading) {
                                                BackButton {
                                                    viewModel.threeDSecureRequest = nil
                                                }
                                            }
                                        }
                                }
                            }
                        })
                        .onChange(of: viewModel.paymentResult, perform: { newValue in
                            guard let newValue = newValue else {
                                return
                            }
                            
                            status = newValue.status
                            showPaymentResultView.toggle()
                        })
                        .onChange(of: viewModel.tokenizedId, perform: { newValue in
                            guard let newValue = newValue else { return }
                            showProgressView = true
                            PaytrailCardTokenAPIs.getToken(of: newValue, merchantId: merchant.merchantId, secret: merchant.secret) { result in
                                showProgressView = false
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    savedCards = viewModel.savedCards
                                }
                            } else {
                            }
                        })
                        .onAppear {
                            
                            savedCards = viewModel.savedCards
                            
                            PaytrailPaymentAPIs.createPayment(of: merchant.merchantId, secret: merchant.secret, payload: createPayload(), completion: { result in
                                switch result {
                                case .success(let data):
                                    providers = data.providers ?? []
                                    groups = data.groups ?? []
                                    let contentText = "transactionId: \(data.transactionId ?? "Unknown transactionId but succeeded")" +
                                    "\n\ngroups: \(data.groups?.compactMap { $0.name }.description ?? "")" +
                                    "\n\nproviders: \(data.providers?.compactMap { $0.name }.description ?? "")"
                                    print(contentText)
                                case .failure(let error):
                                    // TODO: handel creatPayment error
                                    print(error)
                                }
                            })
                        }
                    }
                    
                    HStack(alignment: .center) {
                        TextButton(text: "Cancel", theme: .light()) {
                            mode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                    NavigationLink("", destination: PaymentResultView(items: $items, status: $status, isShowing: $isShowing), isActive: $showPaymentResultView)
                    
                    
                }
                .navigationBarHidden(true)
                
                VStack {
                    ProgressView()
                        .controlSize(.large)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .visible(showProgressView)
            }
        }
    }
}

extension PaymentWallView {
    class ViewModel: ObservableObject, PaymentDelegate {
        @Published var paymentResult: PaymentResult?
        @Published var currentPaymentRequest: URLRequest?
        @Published var addCardRequest: URLRequest?
        @Published var threeDSecureRequest: URLRequest?
        @Published var tokenizedId: String?
        @Published var isCardSaved: Bool?

        var realm: Realm?
        var savedCards: [TokenizedCard] {
            getSavedCards()
        }
        // 3) Handle payment callbacks
        func onPaymentStatusChanged(_ paymentResult: PaymentResult) {
            print("payment status changed: \(paymentResult.status.rawValue)")
            self.paymentResult = paymentResult
            currentPaymentRequest = nil // Exit payment
            threeDSecureRequest = nil
        }
        
        func onCardTokenizedIdReceived(_ tokenizationResult: TokenizationResult) {
            print("Checkout tokenized id received: \(tokenizationResult.tokenizationId)")
            addCardRequest = nil
            guard tokenizationResult.error == nil, tokenizationResult.status == .ok else {
                print(tokenizationResult.error as Any)
                //  Take care of the tokenization error here if any
                isCardSaved = false
                return
            }
            self.tokenizedId = tokenizationResult.tokenizationId
        }
        
        func getSavedCards() -> [TokenizedCard] {
            realm = try! Realm()
            let cards = realm!.objects(TokenizedCard.self)
            return cards.map { $0 }
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
        
        func clean() {
            addCardRequest = nil
            tokenizedId = nil
            isCardSaved = nil
            threeDSecureRequest = nil
            // payAndAddCardRequest = nil
        }
    }
}
