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
    
    /// PaytrailThemes - the current theme for the view, default .normal()
    public let themes: PaytrailThemes
    
    /// PaymentMethodProvider array needed for the view
    public let providers: [PaymentMethodProvider]
    
    /// PaymentMethodGroup array needed for the view
    public let groups: [PaymentMethodGroup]
    
    /// Current selected payment Binding<URLRequest?> if any
    @Binding public var currentPaymentRequest: URLRequest?
    
    /// PaymentProvidersViewDelegate taking care of payment provider selections, set it for UIViewController only
    public let delegate: PaymentProvidersViewDelegate?
    
    public init(themes: PaytrailThemes = PaytrailThemes(viewMode: .normal()),
                providers: [PaymentMethodProvider],
                groups: [PaymentMethodGroup],
                paymentRequest: Binding<URLRequest?>?,
                delegate: PaymentProvidersViewDelegate? = nil) {
        self.themes = themes
        self.providers = providers
        self.groups = groups
        self._currentPaymentRequest = paymentRequest ?? .constant(nil)
        self.delegate = delegate
    }
    
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
                    ForEach(providers, id: \.icon) { provider in
                        if provider.group == group.id {
                            Button {
                                guard let request = PaytrailPaymentAPIs.initiatePaymentRequest(from: provider) else { return }
                                currentPaymentRequest = request
                                delegate?.onPaymentRequestSelected(of: request)
                            } label: {
                                AsyncImage(url: URL(string: provider.icon ?? ""), scale: 0.5) {
                                    image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
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
    }
}

struct PaymentProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentProvidersView(themes: PaytrailThemes(viewMode: .normal()), providers: [], groups: [], paymentRequest: .constant(nil))
    }
}

