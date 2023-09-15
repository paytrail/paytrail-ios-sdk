//
//  GroupedGridView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import SwiftUI


/// GroupedGridView<Content>
///
/// An internal grid view for displaying the provider image views
///
///
struct GroupedGridView<Content>: View where Content: View {

    @State var headerTitle: String = ""
    @State var hasDivider: Bool = false
    let themes: PaytrailThemes
    @ViewBuilder var content: () -> Content
        
    private enum UIConstants: CGFloat {
        case gridSpacing = 30
        case itemHorizontalSpacing = 20
        case gridDividerHeight = 1.5
    }
    
    private var columns: [GridItem] {
        [ GridItem(.adaptive(minimum: themes.itemSize)) ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.gridSpacing.rawValue) {
            if !headerTitle.isEmpty {
                Text("**\(headerTitle)**")
                // NOTE: MSDK does not support customized font at the moment
                // .font(.custom("RockwellStd-Bold", size: themes.fontSize))
                    .font(.system(size: themes.fontSize))
                    .foregroundColor(themes.foreground)
            }
            LazyVGrid(columns: columns, spacing: UIConstants.itemHorizontalSpacing.rawValue) {
                content()
            }
            if hasDivider {
                Divider()
                    .frame(height: UIConstants.gridDividerHeight.rawValue)
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
