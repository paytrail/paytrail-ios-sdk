//
//  TextButton.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.8.2023.
//

import SwiftUI

struct TextButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 16))
                .frame(width: 100, height: 42)
                .background(
                    RoundedRectangle(cornerRadius: 21)
                        .fill(Color.init("magenta"))
                )
                .foregroundColor(Color.white)
        }
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(text: "Checkout", action: {})
    }
}
