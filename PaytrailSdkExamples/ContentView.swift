//
//  ContentView.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI
import paytrail_ios_sdk

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
                Text("<Payment Status: \(viewModel.paymentStatus)>\n")
                    .bold()
                    .foregroundColor(viewModel.paymentStatus == PaymentStatus.ok.rawValue ? Color.green : Color.red)
                    .visible(!viewModel.paymentStatus.isEmpty)
                
                ForEach(groups, id: \.self) { group in
                    GroupedGrid(headerTitle: group.name ?? "") {
                        ForEach(0..<providerImages.count, id: \.self) { index in
                            if providers[index].group == group.id {
                                Button {
                                    // Start the Payment flow:
                                    // 1) Initiate payment provider URLRequest
                                    guard let request = paymentApis.initiatePaymentRequest(from: providers[index]) else { return }
                                    viewModel.currentPaymentRequest = request
                                    
                                } label: {
                                    Image(uiImage: providerImages[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.gray.opacity(0.1))
                            }
                            
                        }
                    }
                    
                }
                
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
                                        viewModel.paymentStatus = ""
                                    }
                                }
                            }
                    }
                }
            }
        }
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
        @Published var paymentStatus: String = ""
        @Published var currentPaymentRequest: URLRequest?
        // 3) Handle payment callbacks
        func onPaymentStatusChanged(_ status: String) {
            print("payment status changed: \(status)")
            paymentStatus = status
            currentPaymentRequest = nil // Exit payment
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(amount: .constant("10"), status: .constant(.ok))
    }
}
