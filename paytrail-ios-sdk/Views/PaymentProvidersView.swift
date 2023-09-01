//
//  PaymentProvidersView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.7.2023.
//

import SwiftUI

public struct PaymentProvidersView: View {
    
    private let paymentApis = PaytrailPaymentAPIs()
    let themes: PaytrailThemes
    @Binding var providers: [PaymentMethodProvider]
    let groups: [PaymentMethodGroup]
    @Binding var currentPaymentRequest: URLRequest?
    @State private var providerImages: [UIImage] = []
    
    private struct Constants {
        static let providerWidth: CGFloat = 100
        static let providerHeight: CGFloat = 56
        static let providerCornerRadius: CGFloat = 8
        static let providerShadowRadius: CGFloat = 4
        static let providerImagePadding: CGFloat = 8
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(groups, id: \.self) { group in
                GroupedGridView(headerTitle: group.name ?? "", hasDivider: false, themes: themes) {
                    ForEach(0..<providerImages.count, id: \.self) { index in
                        if providers[index].group == group.id {
                            Button {
                                guard let request = paymentApis.initiatePaymentRequest(from: providers[index]) else { return }
                                currentPaymentRequest = request
                                
                            } label: {
                                Image(uiImage: providerImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(Constants.providerImagePadding)
                                    .invertColor(themes.inverted)
                            }
                            .frame(width: Constants.providerWidth, height: Constants.providerHeight)
                            .background(
                                RoundedRectangle(cornerRadius: Constants.providerCornerRadius)
                                    .fill(themes.background)
                                    .shadow(
                                        color: themes.shadow,
                                        radius: Constants.providerShadowRadius,
                                        x: 0,
                                        y: 0
                                     )
                            )
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
                        PTLogger.log(message: "Render image failure: \(failure.localizedDescription)", level: .warning)
                        providerImages.append(UIImage(systemName: "exclamationmark.square") ?? UIImage())
                    }
                }
            }
        })
    }
}

struct PaymentProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentProvidersView(themes: PaytrailThemes(viewMode: .normal()), providers: .constant([]), groups: [], currentPaymentRequest: .constant(nil))
    }
}
