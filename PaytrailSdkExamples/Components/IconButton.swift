//
//  IconButton.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.8.2023.
//

import SwiftUI

struct IconButton: View {
    let name: String
    let size: CGFloat
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Icon(name: name, size: size)
        }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(name: "close", size: 24, action: {})
    }
}
