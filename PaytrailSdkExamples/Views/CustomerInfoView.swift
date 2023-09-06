//
//  CustomerInfoView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct CustomerInfoView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Binding var items: [ShoppingItem]
    
    @State private var customer: Customer?
    @State private var fullAddress: Address?
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var address: String = ""
    @State private var postalCode: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var isTermsAgreed: Bool = false
    
    @State private var showPaymentWall: Bool = false
    @Binding var isShowing: Bool
    
    private func prefillData() {
        firstName = "Maija"
        lastName = "Meikalainen"
        phone = "0401886666"
        email = "tester@test.com"
        
        address = "Loremipsunkuja 1b"
        postalCode = "00100"
        city = "Helsinki"
        country = "Finland"
        
        isTermsAgreed = true
    }
    
    private func createCustomer() {
        customer = Customer(email: email, firstName: firstName, lastName: lastName, phone: phone)
        fullAddress = Address(streetAddress: address, postalCode: postalCode, city: city, country: country)
    }
    
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
                        Text("**Customer Details**")
                            .font(.system(size: 24))
                            .padding(.vertical, 10)
                            .foregroundColor(Color.black)
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
                        
                        InfoTextField(placeholder: "Country", text: $country) {
                            
                        }
                        
                        // Terms
                        Toggle(isOn: $isTermsAgreed) {
                             Text("I have read and accepted the order and contract terms.")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.black)
                         }
                        .toggleStyle(AppCheckboxStyle())
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
                    TextButton(text: "To Payments", theme: .fill()) {
                        createCustomer()
                        showPaymentWall.toggle()
                    }
                    .disabled(!isTermsAgreed)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            
                NavigationLink("", destination: PaymentWallView( items: $items, customer: $customer, fullAddress: $fullAddress, isShowing: $isShowing), isActive: $showPaymentWall)
            }
            .navigationBarHidden(true)
            .onAppear {
                prefillData()
            }
        }
    }
}

struct CustomerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerInfoView(items: .constant([]), isShowing: .constant(true))
    }
}
