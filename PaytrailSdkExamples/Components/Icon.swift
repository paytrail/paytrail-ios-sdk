//
//  Icon.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 25.8.2023.
//

import SwiftUI

struct Icon: View {
    let name: String
    let size: CGFloat
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(name: "logo", size: 46)
    }
}
