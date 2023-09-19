//
//  PaymentResultView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 1.9.2023.
//

import SwiftUI

struct PaymentResultView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    @Binding var items: [ShoppingItem]
    @Binding var status: PaymentStatus
    @Binding var isShowing: Bool
    
    var headerText: String {
        switch status {
        case .ok:
            return "Great!"
        case .fail:
            return "Sorry.."
        case .pending:
            return "Pending"
        case .delayed:
            return "Delayed"
        default:
            return "Unknown"
        }
    }
    
    var bodyText: String {
        switch status {
        case .ok:
            return "Your payment is done succesfully! Please Go back to shop."
        case .fail:
            return "Your payment has failed. Please try again."
        case .pending:
            return "Your payment is pending. Please return to shop."
        case .delayed:
            return "Your payment is delayed. Please return to shop."
        default:
            return "Unknown payment status, please return to shop."
        }
    }
    
    var bodyButonText: String {
        switch status {
        case .ok:
            return "Continue shopping"
        case .fail:
            return "Try again"
        case .pending:
            return "Return"
        case .delayed:
            return "Return"
        default:
            return "Return"
        }
    }

    var body: some View {
        AppBackgroundView {
            VStack {
                HeaderView(itemCount: items.count)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .background(Color.white)
                
                HStack {
                    Spacer()
                    Text("**\(headerText)**")
                        .font(.system(size: 24))
                        .foregroundColor(Color.black)
                    //                    .bold()
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                .padding(.horizontal, 24)
                
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        Text(bodyText)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .foregroundColor(Color.black)

                        TextButton(text: bodyButonText, theme: .fill()) {
                            mode.wrappedValue.dismiss()
                            isShowing = false
                            items = [
                                ShoppingItem(id: "#1234", productName: "Paytrail Umbrella", description: "", units: 1, price: Int(15.00), image: "umbrella", currency: "€", upperLimit: 10000),
                                ShoppingItem(id: "#5678", productName: "Paytrail drinking bottle", description: "", units: 1, price: Int(20.00), image: "bottle", currency: "€", upperLimit: 5000)
                            ]
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .visible(status == .ok || status == .pending || status == .delayed)
                        
                        TextButton(text: bodyButonText, theme: .light()) {
                            mode.wrappedValue.dismiss()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .visible(status == .fail || status == .none)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(
                                color: Color.gray.opacity(0.5),
                                radius: 3,
                                x: 5,
                                y: 5
                            )
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                if status == .ok || status == .pending || status == .delayed {
                    items = []
                }
            }
        }
        
    }
}

struct PaymentResultView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentResultView(items: .constant([]), status: .constant(.ok), isShowing: .constant(true))
    }
}
