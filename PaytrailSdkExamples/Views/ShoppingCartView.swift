//
//  ShoppingCardView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.8.2023.
//

import SwiftUI

struct ShoppingCartView: View {
    
    @State var items: [ShoppingItem] = [
        ShoppingItem(id: "#1234", productName: "Paytrail Umbrella", description: "", units: 1, price: Int64(15.00), image: "umbrella", currency: "€", upperLimit: 10000),
        ShoppingItem(id: "#5678", productName: "Paytrail drinking bottle", description: "", units: 1, price: Int64(20.00), image: "bottle", currency: "€", upperLimit: 5000)
    ]
        
    @State private var showCustomerDetailsView: Bool = false
    
    var sum: Int {
        items.map { Int($0.price) * $0.units }.reduce(0,+)
    }
    
    private func updateItem(with newItem: ShoppingItem) {
        guard items.contains(newItem),let index =  items.firstIndex(of: newItem) else {
            return
        }
        items.remove(at: index)
        items.insert(newItem, at: index)
    }
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                // Header view
                HeaderView(itemCount: items.count)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .background(Color.white)
                // Content view
                ScrollView() {
                    VStack(alignment: .leading) {
                        // Shopping cart title
                        Text("Shopping cart")
                            .font(.system(size: 24))
                            .padding(.vertical, 10)
                            .bold()
                        // List of shopping cart items
                        ForEach(items) { item in
                            ShoppingCartItemView(item: Binding(get: { item }, set: { newValue in
                                updateItem(with: newValue)
                            }))
                        }
                        .padding(.bottom, 12)
                        
                        Divider()
                            .frame(minHeight: 1)
                            .overlay(Color.black)
                            .padding(.top,20)

                        // Total price
                        HStack {
                            Text("Total price")
                                .font(.system(size: 20))
                                .bold()
                            Spacer()
                            Text("\(sum) €")
                                .font(.system(size: 20))
                                .bold()
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Footer view
                HStack(alignment: .center) {
                    Spacer()
                    // Order button
                    TextButton(text: "Continue", theme: .fill()) {
                        showCustomerDetailsView.toggle()
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                NavigationLink("", destination: CustomerInfoView(items: $items), isActive: $showCustomerDetailsView)
            }
            .background(Color.init("lightGray"))
        }
        .navigationBarHidden(true)

    }
}

struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartView()
    }
}
