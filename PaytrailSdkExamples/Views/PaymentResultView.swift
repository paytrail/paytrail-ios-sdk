//
//  PaymentResultView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 1.9.2023.
//

import SwiftUI

struct PaymentResultView: View {
    
    @Binding var items: [ShoppingItem]
    @Binding var status: PaymentStatus
    
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
            return "Your payment was done succesfully! Go back to shop."
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
            HeaderView(itemCount: items.count)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .background(Color.white)
            
            HStack {
                Spacer()
                Text(headerText)
                    .font(.system(size: 24))
                    .bold()
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
                    TextButton(text: bodyButonText, theme: .fill()) {
                        //                        mode.wrappedValue.dismiss()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .visible(status == .ok)
                    
                    TextButton(text: bodyButonText, theme: .light()) {
                        //                        mode.wrappedValue.dismiss()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .visible(status != .ok)
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
    }
}

struct PaymentResultView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentResultView(items: .constant([]), status: .constant(.ok))
    }
}
