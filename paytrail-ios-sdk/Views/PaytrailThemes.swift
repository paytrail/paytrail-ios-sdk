//
//  PaytrailThemes.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 6.7.2023.
//

import Foundation
import SwiftUI

public enum PaytrailViewMode {
    case normal(background: Color = Color.white)
    case dark(background: Color = Color.black)
}

public struct PaytrailThemes {
    let viewMode: PaytrailViewMode
    
    var background: Color {
        switch viewMode {
        case .normal(let background):
            return background
        case .dark(let background):
            return background
        }
    }
    
    var shadow: Color {
        switch viewMode {
        case .normal(_):
            return Color.gray.opacity(0.3)
        case .dark(_):
            return Color.white.opacity(0.3)
        }
    }
    
    var inverted: Bool {
        switch viewMode {
        case .normal(_):
            return false
        case .dark(_):
            return true
        }
    }
}
