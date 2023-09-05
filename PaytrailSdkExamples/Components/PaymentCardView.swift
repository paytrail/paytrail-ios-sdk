//
//  PaymentCardView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 5.9.2023.
//

import SwiftUI

struct PaymentCardView: View {
    let card: TokenizedCard
    let action: () -> Void
    var name: String {
        card.type.lowercased() == "visa" ? "visa" : "masterCard"
    }
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Icon(name: name, size: 60)
                Text("****")
                    .font(.system(size: 16))
                    .frame(alignment: .centerFirstTextBaseline)
                Text("**\(card.partialPan)**")
                    .font(.system(size: 16))
                //                Spacer()
            }
            .padding(.trailing, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(
                        color: Color.gray.opacity(0.5),
                        radius: 3,
                        x: 2,
                        y: 2
                     )
            )
        }
    }
}

struct PaymentCardView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardView(card: TokenizedCard(token: "", customer: nil, type: "visa", partialPan: "0123", expireYear: "", expireMonth: "", cvcRequired: "", bin: "", funding: "", countryCode: "", category: "", cardFingerprint: "", panFingerprint: ""), action: {})
    }
}
