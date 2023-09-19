//
//  PaymentProvidersView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.7.2023.
//

import SwiftUI


/// PaymentProvidersView
///
/// A SwiftUI view for showing the available pre-ordered Payment Providers. For a counterpart for an UIViewController, see 'PaymentUIViewsLoader'
///
public struct PaymentProvidersView: View {
        
    struct ProviderWithImage: Hashable {
        let provider: PaymentMethodProvider
        let image: UIImage
    }
    
    /// PaytrailThemes - the current theme for the view, default .normal()
    public let themes: PaytrailThemes
    
    /// Binding<[PaymentMethodProvider]> needed for the view
    @Binding public var providers: [PaymentMethodProvider]
    
    /// PaymentMethodGroup array needed for the view
    public let groups: [PaymentMethodGroup]
    
    /// Current selected payment Binding<URLRequest?> if any
    @Binding public var currentPaymentRequest: URLRequest?
    
    /// ProviderWithImage array, loaded once the providers data is provided
    @State private var providersWithImages: [ProviderWithImage] = []
    
    public init(themes: PaytrailThemes = PaytrailThemes(viewMode: .normal()), providers: Binding<[PaymentMethodProvider]>, groups: [PaymentMethodGroup], paymentRequest: Binding<URLRequest?>) {
        self.themes = themes
        self._providers = providers
        self.groups = groups
        self._currentPaymentRequest = paymentRequest
    }
    
    private struct Constants {
        static let providerWidth: CGFloat = 100
        static let providerHeight: CGFloat = 56
        static let providerCornerRadius: CGFloat = 8
        static let providerShadowRadius: CGFloat = 4
        static let providerImagePadding: CGFloat = 8
    }
    
    private func loadImages() {
        for provider in providers {
            PaytrailPaymentAPIs.renderPaymentProviderImage(by: provider.icon ?? "") { result in
                switch result {
                case .success(let success):
                    providersWithImages.append(ProviderWithImage(provider: provider, image: success))
                case .failure(let failure):
                    PTLogger.log(message: "Render image failure: \(failure.localizedDescription)", level: .warning)
                    let defaultImage = UIImage(systemName: "exclamationmark.square") ?? UIImage()
                    providersWithImages.append(ProviderWithImage(provider: provider, image: defaultImage))
                }
            }
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(groups, id: \.self) { group in
                GroupedGridView(headerTitle: group.name ?? "", hasDivider: false, themes: themes) {
                    ForEach(providersWithImages, id: \.self) { providerWithImage in
                        if providerWithImage.provider.group == group.id {
                            Button {
                                guard let request = PaytrailPaymentAPIs.initiatePaymentRequest(from: providerWithImage.provider) else { return }
                                currentPaymentRequest = request
                            } label: {
                                Image(uiImage: providerWithImage.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(Constants.providerImagePadding)
                            }
                            .frame(width: themes.itemSize, height: Constants.providerHeight)
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
        .onChange(of: providers) { _ in
            loadImages()
        }
    }
}

struct PaymentProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentProvidersView(themes: PaytrailThemes(viewMode: .normal()), providers: .constant([]), groups: [], paymentRequest: .constant(nil))
    }
}

