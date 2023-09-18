//
//  PaytrailThemes.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import Foundation
import SwiftUI



/// PaytrailViewMode for setting the basic forground and background colors
public enum PaytrailViewMode {
    case normal(background: Color = Color.white, foreground: Color = Color.black)
    case dark(background: Color = Color.black, foreground: Color = Color.white)
}

/// PaytrailThemes
///
/// Themes for the MSDK'S PaymentProvidersView. MSDK does not support customized font at the moment.
///
public struct PaytrailThemes {
    
    ///  PaytrailViewMode - view mode of the PaymentProvidersView, You can set the desirous colors of normal or dark mode or use the defaults ones
    public let viewMode: PaytrailViewMode
    
    /// The font size of the PaymentProvidersView, default is small
    public let fontSize: CGFloat
    
    /// The item size (width) in 'PaymentProvidersView', default is large
    public let itemSize: CGFloat
    
    public struct FontSize {
        public static let small: CGFloat = 16
        public static let large: CGFloat = 20
        public static func custom(_ size: CGFloat) -> CGFloat { size }
    }
    
    public struct ItemSize {
        public static let small: CGFloat = 70
        public static let large: CGFloat = 100
    }
    
    public init(viewMode: PaytrailViewMode, fontSize: CGFloat = FontSize.small, itemSize: CGFloat = ItemSize.large) {
        self.viewMode = viewMode
        self.fontSize = fontSize
        self.itemSize = itemSize
    }
    
    var background: Color {
        switch viewMode {
        case .normal(let background, _):
            return background
        case .dark(let background, _):
            return background
        }
    }
    
    var foreground: Color {
        switch viewMode {
        case .normal(_, let foreground):
            return foreground
        case .dark(_, let foreground):
            return foreground
        }
    }
    
    var shadow: Color {
        switch viewMode {
        case .normal(_, _):
            return Color.gray.opacity(0.3)
        case .dark(_, _):
            return Color.white.opacity(0.3)
        }
    }
}

