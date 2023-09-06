//
//  PaymentsView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 30.8.2023.
//

import SwiftUI

struct PaymentsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @Binding var items: [ShoppingItem]
    @Binding var customer: Customer?
    @Binding var fullAddress: Address?
    @Binding var isShowing: Bool
    
    @State private var showPayWithProvidersView: Bool = false

    var body: some View {
        AppBackgroundView {
            VStack {
                // Header view
                HeaderView(itemCount: items.count)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .background(Color.white)
                
                // Content
                VStack(alignment: .leading, spacing: 0) {
                    // Shopping cart title
                    Text("**Select Payment**")
                        .font(.system(size: 24))
                        .padding(.vertical, 10)
                    
                    if #available(iOS 16.0, *) {
                        List {
                            Button {
                                
                            } label: {
                                Text("**Pay with saved cards**")
                            }
                            
                            Button {
                                showPayWithProvidersView.toggle()
                            } label: {
                                Text("**Pay with another provider**")
                            }
                            
                        }
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                        .padding(.horizontal, -16)
                    } else {
                        // Fallback on earlier versions
                        List {
                            Button {
                                
                            } label: {
                                Text("**Pay with saved cards**")
                            }
                            
                            Button {
                                showPayWithProvidersView.toggle()
                            } label: {
                                Text("**Pay with another provider**")
                            }
                            
                        }
                        .padding(.horizontal, -16)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Footer
                HStack(alignment: .center) {
                    TextButton(text: "Cancel", theme: .light()) {
                        mode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                NavigationLink("", destination: PaymentWallView(items: $items, customer: $customer, fullAddress: $fullAddress, isShowing: $isShowing), isActive: $showPayWithProvidersView)
            }
            .navigationBarHidden(true)
        }
    }
}

struct PaymentsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentsView(items: .constant([]), customer: .constant(nil), fullAddress: .constant(nil), isShowing: .constant(true))
    }
}
