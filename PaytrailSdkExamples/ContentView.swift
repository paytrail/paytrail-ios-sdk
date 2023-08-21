//
//  ContentView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var amount: String
    @Binding var status: PaymentStatus
    @State private var contentText: String = ""
    @State private var providers: [PaymentMethodProvider] = []
    @State private var groups: [PaymentMethodGroup] = []
    @State private var providerImages: [UIImage] = []
    @StateObject private var viewModel = ViewModel()
    private let paymentApis = PaytrailPaymentAPIs()
    private let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("<Payment result: \(viewModel.paymentResult?.status.rawValue ?? "")>\n")
                    .bold()
                    .foregroundColor(viewModel.paymentResult?.status == .ok ? Color.green : Color.red)
                    .visible(viewModel.paymentResult != nil)
                
                PaymentProvidersView(themes: PaytrailThemes(viewMode: .dark(background: Color.black.opacity(1), foreground: Color.yellow.opacity(0.9))), providers: $providers, groups: groups, currentPaymentRequest: Binding(get: { viewModel.currentPaymentRequest }, set: { request in
                    viewModel.currentPaymentRequest = request
                }))
                
                Text(contentText)

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
        .background(Color.black.opacity(0.9))
        .onChange(of: viewModel.paymentResult, perform: { newValue in
            guard let newValue = newValue else {
                return
            }
            switch newValue.status {
            case .ok:
                print("payment ok!")
                status = .ok
                mode.wrappedValue.dismiss()
                
                //                paymentApis.getPayment(of: merchant.merchantId, secret: merchant.secret, transactionId: "cfaa43a2-0c4e-11ee-829b-a75b998e8f55") { result in
                //                    print(result)
                //                }
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
                                             amount: (Int64(amount) ?? 1) * 100,
                                             currency: .eur,
                                             language: .fi,
                                             items: [Item(unitPrice: (Int64(amount) ?? 1) * 100, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                             customer: Customer(email: "test.customer@example.com"),
                                             redirectUrls: CallbackUrls(success: "https://www.paytrail.com/succcess", cancel: "https://www.paytrail.com/fail"),
                                             callbackUrls: CallbackUrls(success: "https://qvik.com", cancel: "https://qvik.com"))
            paymentApis.createPayment(of: merchant.merchantId, secret: merchant.secret, payload: payload, completion: { result in
                switch result {
                case .success(let data):
                    
                    //                    if let body = try? JSONSerialization.data(withJSONObject: jsonEncode(of: data), options: .prettyPrinted) {
                    //                        print(String(data: body, encoding: .utf8)!)
                    //                    }
                    providers = data.providers ?? []
                    groups = data.groups ?? []
                    contentText = "transactionId: \(data.transactionId ?? "Unknown transactionId but success")" +
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
                    contentText = (error as? any PaytrailError)?.description ?? ""
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(amount: .constant("10"), status: .constant(.ok))
    }
}
