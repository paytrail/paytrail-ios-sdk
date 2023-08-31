//
//  PayWithProvidersView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 31.8.2023.
//

import SwiftUI

struct PayWithProvidersView: View {
    
    @Binding var items: [ShoppingItem]
    @Binding var customer: Customer?
    @Binding var fullAddress: Address?
    
    @State private var providers: [PaymentMethodProvider] = []
    @State private var groups: [PaymentMethodGroup] = []
    @State private var providerImages: [UIImage] = []
    
    var body: some View {
        AppBackgroundView {
            // Header view
            HeaderView(itemCount: items.count)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .background(Color.white)
            
            VStack(alignment: .leading) {
                Text("Choose payment method")
                    .font(.system(size: 24))
                    .bold()
                .padding(.vertical, 10)
                
                Text("By selecting a payment method, you agree to our payment service terms & conditions.")
                    .font(.system(size: 12))
                
//                PaymentProvidersView(themes: PaytrailThemes(viewMode: .light()), providers: $providers, groups: groups, currentPaymentRequest: Binding(get: { viewModel.currentPaymentRequest }, set: { request in
//                    viewModel.currentPaymentRequest = request
//                }))
                
            }
            .padding(.horizontal, 24)

            
            Spacer()
        }
    }
}

struct PayWithProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        PayWithProvidersView(items: .constant([]), customer: .constant(nil), fullAddress: .constant(nil))
    }
}
