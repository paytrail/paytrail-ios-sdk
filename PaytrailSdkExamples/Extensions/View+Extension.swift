//
//  View+Extension.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 13.6.2023.
//

import Foundation
import SwiftUI


extension View {
     /// Returns a view that is visible or not visible based on `isVisible`.
    func visible(_ isVisible: Bool) -> some View {
        modifier(VisibleModifier(isVisible: isVisible))
    }
}

private struct VisibleModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        Group {
            if isVisible {
                content
            } else {
                EmptyView()
            }
        }
    }
}
