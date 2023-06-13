//
//  GroupedGridItem.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 13.6.2023.
//

import Foundation
import SwiftUI

struct GroupedGridItem<Content>: View where Content: View {

    @State var headerTitle: String = ""
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !headerTitle.isEmpty {
                Text(headerTitle)
                    .bold()
            }
            VStack(alignment: .center) {
                content()
            }
        }
    }
}

struct GroupedListRow_Previews: PreviewProvider {
    static var previews: some View {
        GroupedGridItem(headerTitle: "header!") {
            Text("haha")
        }
    }
}
