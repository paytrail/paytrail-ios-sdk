//
//  GroupedGridView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import SwiftUI

struct GroupedGridView<Content>: View where Content: View {

    @State var headerTitle: String = ""
    @ViewBuilder var content: () -> Content
    private let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !headerTitle.isEmpty {
                Text(headerTitle)
                    .bold()
            }
            LazyVGrid(columns: columns, spacing: 20) {
                content()
            }
        }
    }
}

struct GroupedGridView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedGridView(headerTitle: "Items Header") {
            VStack {
                Text("Item1")
                Text("Item2")
                Text("Item3")
                Text("Item4")
                Text("Item5")
                Text("Item6")
            }
        }
    }
}
