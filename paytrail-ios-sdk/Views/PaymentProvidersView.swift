//
//  PaymentProvidersView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.7.2023.
//

import SwiftUI

public struct PaymentProvidersView: View {
    
    private let paymentApis = PaytrailPaymentAPIs()
    @Binding var providers: [PaymentMethodProvider]
    let groups: [PaymentMethodGroup]
    @Binding var currentPaymentRequest: URLRequest?
    @State private var providerImages: [UIImage] = []

    public var body: some View {
        VStack(alignment: .leading) {
            ForEach(groups, id: \.self) { group in
                GroupedGridView(headerTitle: group.name ?? "") {
                    ForEach(0..<providerImages.count, id: \.self) { index in
                        if providers[index].group == group.id {
                            Button {
                                // Start the Payment flow:
                                // 1) Initiate payment provider URLRequest
                                guard let request = paymentApis.initiatePaymentRequest(from: providers[index]) else { return }
                                currentPaymentRequest = request
                                
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
            
        }
        .onChange(of: providers, perform: { newValue in
            for provider in newValue {
                paymentApis.renderPaymentProviderImage(by: provider.icon ?? "") { result in
                    switch result {
                    case .success(let success):
                        providerImages.append(success)
                    case .failure(let failure):
                        print("Render image failure: \(failure.localizedDescription)")
                        providerImages.append(UIImage(systemName: "exclamationmark.square") ?? UIImage())
                    }
                }
            }
        })
    }
}

struct PaymentProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentProvidersView(providers: .constant([]), groups: [], currentPaymentRequest: .constant(nil))
    }
}
