//
//  GroupedGridItem.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 13.6.2023.
//

import Foundation
import SwiftUI

struct GroupedGrid<Content>: View where Content: View {

    @State var headerTitle: String = ""
    @ViewBuilder var content: () -> Content
    private let columns = [
//        GridItem(.flexible(minimum: 150, maximum: 200))
        GridItem(.adaptive(minimum: 150))

    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !headerTitle.isEmpty {
                Text("**\(headerTitle)**")
            }
            LazyVGrid(columns: columns, spacing: 8) {
                content()
            }
        }
    }
}

struct GroupedListRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupedGrid(headerTitle: "header!") {
            Text("haha")
        }
    }
}
