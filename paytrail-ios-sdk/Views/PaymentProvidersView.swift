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
/// **Properties:**
/// - themes: PaytrailThemes - the current theme for the view, default .normal()
/// - providers: Binding<[PaymentMethodProvider]> - providers data
/// - groups: [PaymentMethodGroup] - groups data
/// - currentPaymentRequest: Binding<URLRequest?> - current selected payment URLRequest if any
///

public struct PaymentProvidersView: View {
        
    public let themes: PaytrailThemes
    @Binding public var providers: [PaymentMethodProvider]
    public let groups: [PaymentMethodGroup]
    @Binding public var currentPaymentRequest: URLRequest?
    
    @State private var providerImages: [UIImage] = []
    
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

