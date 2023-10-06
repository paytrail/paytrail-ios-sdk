//
//  PaymentProvidersVCView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 13.9.2023.
//

import SwiftUI


/// PaymentProvidersViewDelegate
///
/// A public protocol for PaymentProvidersVCView handling subsequent payment request
///
public protocol PaymentProvidersViewDelegate {
    
    /// onPaymentRequestSelected
    /// - Parameter request: current selected payment provider URLRequest
    func onPaymentRequestSelected(of request: URLRequest)
}

/// PaymentProvidersVCView
///
/// A counterpart of 'PaymentProvdidersView' to be used in an UIViewController, see 'PaymentUIViewsLoader'. The view is loaded in 'PaymentUIViewsLoader' so no need to use on its own.
///
struct PaymentProvidersVCView: View {
    
    /// A PaymentMethodProvider with UIImage
    struct ProviderWithImage: Hashable {
        let provider: PaymentMethodProvider
        let image: UIImage
    }
    
    /// PaytrailThemes - the current theme for the view, default .normal()
    let themes: PaytrailThemes
    
    /// [PaymentMethodProvider] needed for the view
    let providers: [PaymentMethodProvider]
    
    /// [PaymentMethodGroup] needed for the view
    let groups: [PaymentMethodGroup]
    
    /// PaymentProvidersVCViewDelegate taking care of payment provider selections
    let delegate: PaymentProvidersViewDelegate? // View delegate for when used in an UIViewController
    
    /// ProviderWithImage array, loaded once the providers data is provided
    @State private var providersWithImages: [ProviderWithImage] = []
    
    init(themes: PaytrailThemes = PaytrailThemes(viewMode: .normal()), providers: [PaymentMethodProvider], groups: [PaymentMethodGroup], delegate: PaymentProvidersViewDelegate?) {
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
        guard providersWithImages.count == 0 else { return }
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

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(groups, id: \.self) { group in
                GroupedGridView(headerTitle: group.name ?? "", hasDivider: false, themes: themes) {
                    ForEach(providersWithImages, id: \.self) { providerWithImage in
                        if providerWithImage.provider.group == group.id {
                            Button {
                                guard let request = PaytrailPaymentAPIs.initiatePaymentRequest(from: providerWithImage.provider) else { return }
                                delegate?.onPaymentRequestSelected(of: request)
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
