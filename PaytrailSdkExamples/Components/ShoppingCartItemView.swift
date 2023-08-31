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
                Icon(name: item.image, size: 80)
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
                        let newUnits = item.units - 1 >= 0 ? item.units - 1 : 0
                        item.updateUnits(of: newUnits)
                    })
                    Text("\(item.units)")
                        .frame(width: 60)
                    IconButton(name: "plus", size: 32, action: {
                        let newUnits = item.units + 1 <= item.upperLimit ? item.units + 1 : item.upperLimit
                        item.updateUnits(of: newUnits)
                    })
                }
                .border(Color.gray.opacity(0.5))
            }
            .padding(.bottom, 16)
            .padding(.trailing, 16)
            
        }
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
        .padding(.trailing, 8)
    }

}

struct ShoppingCartItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartItemView(item: .constant(ShoppingItem(id: UUID().uuidString, productName: "Paytrail Umbrella Umbrella Umbrella", description: "", units: 1, price: Int64(15.00), image: "umbrella", currency: "€", upperLimit: 10000)))
    }
}
