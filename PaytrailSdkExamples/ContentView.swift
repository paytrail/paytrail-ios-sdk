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
    private let paymentApis = PaytrailPaymentAPIs()
    var body: some View {
        ScrollView {
            VStack {
                //                Image(systemName: "globe")
                //                    .imageScale(.large)
                //                    .foregroundColor(.accentColor)
                //                Text(contentText)
                Text("Bloody Providers:")
                    .bold()
                ForEach(0..<providerImages.count, id: \.self) { index in
                    Button {
                        guard let urlString = providers[index].url, let params = providers[index].parameters, let url = makeUrl(of: urlString, params: params)  else { return }
                        //                        guard let url = URL(string: providers[index].url ?? "") else  { return }
                        openURL(url)
                        
                    } label: {
                        Image(uiImage: providerImages[index])
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
        .onAppear {
            let merchant = PaytrailMerchant(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
        
            let payload = PaymentRequestBody(stamp: UUID().uuidString,
                                             reference: "3759170",
                                             amount: 1525,
                                             currency: "EUR",
                                             language: "FI",
                                             items: [Item(unitPrice: 1525, units: 1, vatPercentage: 24, productCode: "#1234", stamp: "2018-09-12")],
                                             customer: Customer(email: "test.customer@example.com"),
                                             redirectUrls: CallbackUrls(success: "google.com", cancel: "google.com"),
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
    
    func makeUrl(of urlString: String, params: [Parameter]) -> URL? {
        guard var urlComponent = URLComponents(string: urlString) else { return nil }
        
        var queryItems: [URLQueryItem] = []
        
        params.forEach {
            let urlQueryItem = URLQueryItem(name: $0.name ?? "", value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        print(url)
        return url
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
