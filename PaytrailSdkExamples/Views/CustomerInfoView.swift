//
//  CustomerInfoView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct CustomerInfoView: View {
    
    @Binding var items: [ShoppingItem]
    
    var body: some View {

        // Header view
        HeaderView(itemCount: items.count)
        
        
    }
}

struct CustomerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerInfoView(items: .constant([]))
    }
}
