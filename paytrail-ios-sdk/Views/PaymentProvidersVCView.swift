//
//  PaymentProvidersVCView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 13.9.2023.
//

import SwiftUI

public struct PaymentProvidersVCView: View {
    
    public let themes: PaytrailThemes
    public let providers: [PaymentMethodProvider]
    public let groups: [PaymentMethodGroup]
    public var delegate: PaymentProvidersVCViewDelegate? // View delegate for when used in an UIViewController
    @State private var providerImages: [UIImage] = []
    
    public init(themes: PaytrailThemes = PaytrailThemes(viewMode: .normal()), providers: [PaymentMethodProvider], groups: [PaymentMethodGroup], delegate: PaymentProvidersVCViewDelegate?) {
        self.themes = themes
        self.providers = providers
        self.groups = groups
        self.delegate = delegate
    }
    
    private struct Constants {
        static let providerWidth: CGFloat = 100
        static let providerHeight: CGFloat = 56
        static let providerCornerRadius: CGFloat = 8
        static let providerShadowRadius: CGFloat = 4
        static let providerImagePadding: CGFloat = 8
    }
    
    private func loadImages() {
        guard providerImages.count == 0 else { return }
        for provider in providers {
            PaytrailPaymentAPIs.renderPaymentProviderImage(by: provider.icon ?? "") { result in
                switch result {
                case .success(let success):
                    providerImages.append(success)
                case .failure(let failure):
                    PTLogger.log(message: "Render image failure: \(failure.localizedDescription)", level: .warning)
                    let defaultImage = UIImage(systemName: "exclamationmark.square") ?? UIImage()
                    providerImages.append(defaultImage)
                }
            }
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(groups, id: \.self) { group in
                GroupedGridView(headerTitle: group.name ?? "", hasDivider: false, themes: themes) {
                    ForEach(0..<providerImages.count, id: \.self) { index in
                        if providers[index].group == group.id {
                            Button {
                                guard let request = PaytrailPaymentAPIs.initiatePaymentRequest(from: providers[index]) else { return }
                                delegate?.onPaymentRequestSelected(of: request)
                                
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
        .onAppear {
            loadImages() // Load images here when used in an UIViewController
        }
    }
}

struct PaymentProvidersVCView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentProvidersVCView(themes: PaytrailThemes(viewMode: .normal()), providers: [], groups: [], delegate: nil)
    }
}

public protocol PaymentProvidersVCViewDelegate {
    func onPaymentRequestSelected(of request: URLRequest)
}
