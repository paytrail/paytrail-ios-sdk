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

    var body: some View {
        AppBackgroundView {
            HeaderView(itemCount: items.count)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .background(Color.white)
            
            HStack {
                Spacer()
                Text("Great!")
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
                    Text("Your payment was done succesfully! Go back to shop.")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                    TextButton(text: "Continue shopping", theme: .fill()) {
                        //                        mode.wrappedValue.dismiss()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                }
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
        PaymentResultView(items: .constant([]), status: .constant(.none))
    }
}
