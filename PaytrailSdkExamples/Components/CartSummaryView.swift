//
//  CartSummaryView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.9.2023.
//

import SwiftUI

struct CartSummaryView: View {
    
    let items: [ShoppingItem]
    
    var sum: Int {
        items.map { Int($0.price) * $0.units }.reduce(0,+)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("**Cart summary**")
                .foregroundColor(Color.black)
                .font(.system(size: 20))
                .padding(.bottom, 8)
            
            ForEach(items) { item in
                HStack {
                    Text("\(item.units)")
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                    Text("x")
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                    Text("\(item.productName)")
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                    Spacer()
                    Text("\(item.price) €")
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                }
            }
                        
            Divider()
                .frame(minHeight: 0.5)
                .overlay(Color.black)
                .padding(.top,8)

            // Total price
            HStack {
                Text("**Total price**")
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
                    //                                .bold()
                Spacer()
                Text("**\(sum) €**")
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
            }
            
        }
    }
}

struct CartSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        CartSummaryView(items: [
            ShoppingItem(id: "#1234", productName: "Paytrail Umbrella", description: "", units: 2, price: Int64(15.00), image: "umbrella", currency: "€", upperLimit: 10000),
            ShoppingItem(id: "#5678", productName: "Paytrail drinking bottle", description: "", units: 1, price: Int64(20.00), image: "bottle", currency: "€", upperLimit: 5000)
        ])
    }
}
