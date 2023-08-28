//
//  ShoppingCartItem.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.8.2023.
//

import SwiftUI

struct ShoppingCartItemView: View {
    
    @Binding var item: ShoppingItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Icon(name: item.image, size: 60)
                VStack(alignment: .leading, spacing: 16) {
                    Text(item.productName)
                    Text("\(item.price) \(item.currency)")
                }
                Spacer()
                IconButton(name: "close", size: 24) {
                    // Add later
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            HStack {
                Spacer()
                HStack() {
                    IconButton(name: "minus", size: 32, action: {
                        let newAmount = item.amount - 1 >= 0 ? item.amount - 1 : 0
                        item.updateAmount(of: newAmount)
                    })
                    Text("\(item.amount)")
                        .frame(width: 60)
                    IconButton(name: "plus", size: 32, action: {
                        let newAmount = item.amount + 1 <= item.upperLimit ? item.amount + 1 : item.upperLimit
                        item.updateAmount(of: newAmount)
                    })
                }
                .border(Color.gray.opacity(0.5))
            }
            .padding(.bottom, 16)
            .padding(.trailing, 16)
            
        }
        .border(Color.gray)
        .background(Color.white)
        .onAppear {
        }
        
    }

}

struct ShoppingCartItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartItemView(item: .constant(ShoppingItem(id: UUID().uuidString, productName: "Paytrail Umbrella Umbrella Umbrella", description: "", amount: 1, price: Int64(15.00), image: "umbrella", currency: "€", upperLimit: 10000)))
    }
}
