//
//  AppBackgroundView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct AppBackgroundView<Content: View>: View {
    
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            content()
        }
        .background(Color.gray.opacity(0.2))
    }
}

struct AppBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        AppBackgroundView(content: {
            Text("haha")
        })
    }
}
