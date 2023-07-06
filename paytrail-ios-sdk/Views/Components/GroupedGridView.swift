//
//  GroupedGridView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import SwiftUI

struct GroupedGridView<Content>: View where Content: View {

    @State var headerTitle: String = ""
    @State var hasDivider: Bool = false
    let themes: PaytrailThemes
    @ViewBuilder var content: () -> Content
    private let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            if !headerTitle.isEmpty {
                Text(headerTitle)
                    .bold()
                    .foregroundColor(themes.foreground)
            }
            LazyVGrid(columns: columns, spacing: 20) {
                content()
            }
            if hasDivider {
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.3))
            }
        }
    }
}

struct GroupedGridView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedGridView(headerTitle: "Items Header", themes: PaytrailThemes(viewMode: .normal())) {
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
