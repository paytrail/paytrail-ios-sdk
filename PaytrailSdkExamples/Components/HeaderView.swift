//
//  HeaderView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct HeaderView: View {
    
    let itemCount: Int
    
    var body: some View {
        HStack(spacing: 4) {
            // Logo
            Icon(name: "logo", size: 40)
            Spacer()
            Icon(name: "shopping-cart", size: 20)
            Text("\(itemCount)")
                .foregroundColor(Color.black)
        }
        .padding(.top, 8)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(itemCount: 3)
    }
}
