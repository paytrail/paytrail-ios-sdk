//
//  ContentView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI
import paytrail_ios_sdk

struct ContentView: View {
    
    @Environment(\.openURL) var openURL
    @State private var contentText: String = ""
    @State private var providers: [PaymentMethodProvider] = []
    @State private var providerImages: [UIImage] = []
    @State private var currentPaymentUrl: URL?
    @State private var showingAlert: Bool = false
    @StateObject private var viewModel = ViewModel()
    private let paymentApis = PaytrailPaymentAPIs()
    var body: some View {
        ScrollView {
            VStack {
                Text("Bloody Providers:")
                    .bold()
                ForEach(0..<providerImages.count, id: \.self) { index in
                    Button {
                        // 1) Initiate payment provider URL
                        guard let url = paymentApis.initiatePaymentUrl(of: providers[index]) else { return }
                        currentPaymentUrl = url
                        
                    } label: {
                        Image(uiImage: providerImages[index])
                    }
                    
                }
                //                .alert("Payment \(viewModel.paymentStatus)", isPresented: $showingAlert) {
                //                    Button("Dismiss", role: .cancel) { }
                //                }
            }
            .fullScreenCover(isPresented: Binding(get: { currentPaymentUrl != nil }, set: { _, _ in }), onDismiss: {
                currentPaymentUrl = nil
            }) {
                if let url = currentPaymentUrl {
                    NavigationView {
                        // 2) Load PaymentWebView by the URL and pass a PaymentDelegate for handling payment callbacks
                        PaymentWebView(url: url, delegate: viewModel)
                            .ignoresSafeArea()
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    BackButton {                                    currentPaymentUrl = nil
                                    }
                                }
                            }
                    }
                }
            }
        }
        .padding()
        .onChange(of: providers, perform: { newValue in
            for provider in newValue {
                paymentApis.renderPaymentProviderImage(by: provider.icon ?? "") { result in
                    switch result {
                    case .success(let success):
                        providerImages.append(success)
                    case .failure(let failure):
                        print("Render image failure: \(failure.localizedDescription)")
                    }
                }
            }
        })
        .onChange(of: viewModel.paymentStatus, perform: { newValue in
            switch PaymentStatus(rawValue: newValue) {
            case .ok:
                print("payment ok!")
                showingAlert = true
                currentPaymentUrl = nil
            case .pending:
                print("payment pending!")
                currentPaymentUrl = nil
                showingAlert = true
            case .delayed:
                print("payment delayed!")
                currentPaymentUrl = nil
                showingAlert = true
            case .fail:
                print("payment failed!")
                currentPaymentUrl = nil
                showingAlert = true
            default:
                print(newValue)
            }
        })
        .onAppear {
            let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
        
            let payload = PaymentRequestBody(stamp: UUID().uuidString,
                                             reference: "3759170",
                                             amount: 1025,
                                             currency: "EUR",
                                             language: "FI",
                                             items: [Item(unitPrice: 1025, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                             customer: Customer(email: "test.customer@example.com"),
                                             redirectUrls: CallbackUrls(success: "https://www.paytrail.com", cancel: "https://www.paytrail.com"),
                                             callbackUrls: nil)
            paymentApis.createPayment(of: merchant.merchantId, secret: merchant.secret, payload: payload, completion: { result in
                switch result {
                case .success(let data):
                    providers = data.providers ?? []
                    contentText = "transactionId: \(data.transactionId ?? "Unknown transactionId but success")" +
                    "\nhref: \(data.href ?? "")" +
                    "\nreference: \(data.reference ?? "")" +
                    "\n\nterms: \(data.terms ?? "")" +
                    "\n\ngroups: \(data.groups?.compactMap { $0.name }.description ?? "")" +
                    "\n\nproviders: \(data.providers?.compactMap { $0.name }.description ?? "")"
                    //                    +
                    //                    "\ncustomProviders: \(data.customProviders?.applepay.debugDescription ?? "")"
                    print(contentText)
                case .failure(let error as NSError):
                    print(error)
                    contentText = error.userInfo.description
                }
            })
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject, PaymentDelegate {
        @Published var paymentStatus: String = ""
        // 3) Handle payment callbacks
        func onPaymentStatusChanged(_ status: String) {
            print("payment status changed: \(status)")
            paymentStatus = status
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
