//
//  PaytrailThemes.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import Foundation
import SwiftUI

public enum PaytrailViewMode {
    case normal(background: Color = Color.white, foreground: Color = Color.black)
    case dark(background: Color = Color.black, foreground: Color = Color.white)
}

public struct PaytrailThemes {
    let viewMode: PaytrailViewMode
    let fontSize: CGFloat
    
    public struct FontSize {
        static let small: CGFloat = 16
        static let large: CGFloat = 20
        static func custom(_ size: CGFloat) -> CGFloat { size }
    }
    
    init(viewMode: PaytrailViewMode, fontSize: CGFloat = FontSize.small) {
        self.viewMode = viewMode
        self.fontSize = fontSize
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
    
    var inverted: Bool {
        switch viewMode {
        case .normal(_, _):
            return false
        case .dark(_, _):
            return true
        }
    }
}
