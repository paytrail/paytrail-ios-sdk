//
//  ProductCheckoutView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.6.2023.
//

import SwiftUI

struct ProductCheckoutView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var amount: String = "10"
    @State private var status: PaymentStatus = .none

    private let upperLimit = 200
    private let lowerLimit = 1
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack {
                    Text("Donate:")
                        .bold()
                    
                    TextField("Donation", text: $amount)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: amount) { change in
                            guard let value = Int(change) else {
                                amount = String(lowerLimit)
                                return
                            }
                            if value > upperLimit {
                                amount = String(upperLimit)
                            } else if value <= lowerLimit {
                                amount = String(lowerLimit)
                            }
                        }
                    
                    Text("euro")
                        .bold()
                    
                }
                .padding(.top, 80)
                
                Spacer()
                    .frame(height: 100)
                
                List {
                    NavigationLink {
                        AddCardView(amount: $amount, status: $status)
                    } label: {
                        Text("Pay with saved cards")
                            .bold()
                    }
                    
                    NavigationLink {
                        //                        ContentView(amount: $amount, status: $status)
                    } label: {
                        Text("Pay with another provider")
                            .bold()
                    }
                }
                .listStyle(.plain)
                .scrollDisabled(true)
                
                Text("Thank you!")
                    .font(.largeTitle)
                    .visible(status == .ok)
                
                Spacer()
                    .frame(height: 100)
                
            }
            .padding(.horizontal, 40)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    mode.wrappedValue.dismiss()
                }
            }
        }
        
    }
}

struct ProductCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCheckoutView()
    }
}
