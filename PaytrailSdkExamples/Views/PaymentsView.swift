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
                    Text("Select Payment")
                        .font(.system(size: 24))
                        .bold()
                    .padding(.vertical, 10)
                    
                    List {
                        Button {
                            
                        } label: {
                            Text("Pay with saved cards")
                                .bold()
                        }
                        
                        Button {
                            showPayWithProvidersView.toggle()
                        } label: {
                            Text("Pay with another provider")
                                .bold()
                        }

                    }
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
                    .padding(.horizontal, -16)
                    
                    NavigationLink("", destination: PayWithProvidersView(items: $items, customer: $customer, fullAddress: $fullAddress, status: .constant(.none)), isActive: $showPayWithProvidersView)

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
            }

        }
    }
}

struct PaymentsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentsView(items: .constant([]), customer: .constant(nil), fullAddress: .constant(nil))
    }
}
