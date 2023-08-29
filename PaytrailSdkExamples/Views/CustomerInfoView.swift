//
//  CustomerInfoView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct CustomerInfoView: View {
    
    @Binding var items: [ShoppingItem]
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var postalCode: String = ""
    @State private var city: String = ""
    
    var body: some View {
        AppBackgroundView {
            VStack {
                // Header view
                HeaderView(itemCount: items.count)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .background(Color.white)
                
                // Content
                ScrollView() {
                    VStack(alignment: .leading, spacing: 18) {
                        // Shopping cart title
                        Text("Customer Details")
                            .font(.system(size: 24))
                            .bold()
                            .padding(.vertical, 10)
                        // Customer infos
                        InfoTextField(placeholder: "First name", text: $firstName) {
                            
                        }

                        InfoTextField(placeholder: "Last name", text: $lastName) {
                            
                        }
                        
                        InfoTextField(placeholder: "Phone number", text: $phone) {
                            
                        }
                        
                        InfoTextField(placeholder: "Email", text: $email) {
                            
                        }
                        
                        InfoTextField(placeholder: "Address", text: $address) {
                            
                        }
                        
                        HStack(spacing: 10) {
                            InfoTextField(placeholder: "Postal code", text: $postalCode) {
                                
                            }
                            Spacer()
                            
                            InfoTextField(placeholder: "City", text: $city) {
                                
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Footer
                HStack(alignment: .center) {
                    TextButton(text: "Cancel") {
                        
                    }
                    Spacer()
                    TextButton(text: "Checkout") {
                        
                    }
                }
                .padding(.horizontal, 24)
            }
        }

    }
}

struct CustomerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerInfoView(items: .constant([]))
    }
}
