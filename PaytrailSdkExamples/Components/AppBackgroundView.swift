//
//  AppBackgroundView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct AppBackgroundView<Content: View>: View {
    
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                content()
            }
//            .navigationBarHidden(true)
//            .navigationBarBackButtonHidden(true)
            .background(Color.init("lightGray"))
        }
        .navigationBarHidden(true)
    }
}

struct AppBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        AppBackgroundView(content: {
            Text("haha")
            Text("haha")
            Text("haha")

        })
    }
}
