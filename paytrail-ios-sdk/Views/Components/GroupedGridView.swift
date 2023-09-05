//
//  GroupedGridView.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import SwiftUI


/// GroupedGridView<Content> made to show the list of Payment Providers
///
/// Content: the desired content views to be grided with each view having a minimal width of 100 in CGFloat
struct GroupedGridView<Content>: View where Content: View {

    @State var headerTitle: String = ""
    @State var hasDivider: Bool = false
    let themes: PaytrailThemes
    @ViewBuilder var content: () -> Content
        
    private enum UIConstants: CGFloat {
        case itemMinWidth = 100
        case gridSpacing = 30
        case itemHorizontalSpacing = 20
        case gridDividerHeight = 1.5
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: UIConstants.itemMinWidth.rawValue))
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.gridSpacing.rawValue) {
            if !headerTitle.isEmpty {
                // TODO: Consdier to load the font correctly or use the system one
                Text("**\(headerTitle)**")
                // TODO: Figure out if we can load custom font here
                //                    .font(.custom("RockwellStd-Bold", size: themes.fontSize))
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
