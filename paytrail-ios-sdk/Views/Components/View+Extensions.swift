//
//  View+Extensions.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import Foundation
import SwiftUI

extension View {
     /// Returns a view that is visible or not visible based on `isVisible`.
    func invertColor(_ inverted: Bool) -> some View {
        modifier(InvertColorModifier(inverted: inverted))
    }
}

private struct InvertColorModifier: ViewModifier {
    let inverted: Bool
    func body(content: Content) -> some View {
        Group {
            if inverted {
                content
                    .colorInvert()
            } else {
                content
            }
        }
    }
}
