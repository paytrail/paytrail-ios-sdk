//
//  ContentView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Binding var items: [ShoppingItem]
    @Binding var customer: Customer?
    @Binding var fullAddress: Address?
    
    var amount: Int64 {
        productItems.map { $0.unitPrice * $0.units }.reduce(0,+)
    }
    
    var productItems: [Item] {
        items.map { $0.toProductItem(shoppingItem: $0) }
    }
    
    @Binding var status: PaymentStatus
    //    @State private var contentText: String = ""
    @State private var providers: [PaymentMethodProvider] = []
    @State private var groups: [PaymentMethodGroup] = []
    @State private var providerImages: [UIImage] = []
    @StateObject private var viewModel = ViewModel()
    private let paymentApis = PaytrailPaymentAPIs()
    private let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                
                PaymentProvidersView(themes: PaytrailThemes(viewMode: .normal()), providers: $providers, groups: groups, currentPaymentRequest: Binding(get: { viewModel.currentPaymentRequest }, set: { request in
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
            .padding()
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
                                    BackButton {                                    viewModel.currentPaymentRequest = nil
                                        viewModel.paymentResult = nil
                                    }
                                }
                            }
                    }
                }
            }
        }
        .onChange(of: viewModel.paymentResult, perform: { newValue in
            guard let newValue = newValue else {
                return
            }
            switch newValue.status {
            case .ok:
                print("payment ok!")
                status = .ok
                mode.wrappedValue.dismiss()
            case .pending:
                print("payment pending!")
            case .delayed:
                print("payment delayed!")
            case .fail:
                print("payment failed!")
                if let _ = newValue.error {
                    // Take care of the error when payment fails
                }
            default:
                print("Payment none")
            }
        })
        .onAppear {
            let payload = PaymentRequestBody(stamp: UUID().uuidString,
                                             reference: "3759170",
                                             amount: amount,
                                             currency: .eur,
                                             language: .fi,
                                             items: productItems,
                                             customer: customer!,
                                             redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                                             callbackUrls: CallbackUrls(success: "https://qvik.com/success", cancel: "https://qvik.com/fail"),
                                             deliveryAddress: fullAddress,
                                             invoicingAddress: fullAddress
            )
            
            paymentApis.createPayment(of: merchant.merchantId, secret: merchant.secret, payload: payload, completion: { result in
                switch result {
                case .success(let data):
                    
                    //                    if let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: data), options: .prettyPrinted) {
                    //                        print(String(data: body, encoding: .utf8)!)
                    //                    }
                    providers = data.providers ?? []
                    groups = data.groups ?? []
                    let contentText = "transactionId: \(data.transactionId ?? "Unknown transactionId but success")" +
                    "\nhref: \(data.href ?? "")" +
                    "\nreference: \(data.reference ?? "")" +
                    "\n\nterms: \(data.terms ?? "")" +
                    "\n\ngroups: \(data.groups?.compactMap { $0.name }.description ?? "")" +
                    "\n\nproviders: \(data.providers?.compactMap { $0.name }.description ?? "")"
                    //                    +
                    //                    "\ncustomProviders: \(data.customProviders?.applepay.debugDescription ?? "")"
                    print(contentText)
                case .failure(let error):
                    print(error)
//                    contentText = (error as? any PaytrailError)?.description ?? ""
                }
            })
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject, PaymentDelegate {
        @Published var paymentResult: PaymentResult?
        @Published var currentPaymentRequest: URLRequest?
        // 3) Handle payment callbacks
        func onPaymentStatusChanged(_ paymentResult: PaymentResult) {
            print("payment status changed: \(paymentResult.status.rawValue)")
            self.paymentResult = paymentResult
            currentPaymentRequest = nil // Exit payment
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(amount: .constant("10"), status: .constant(.ok))
//    }
//}
