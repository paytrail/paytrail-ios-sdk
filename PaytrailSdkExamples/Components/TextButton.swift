//
//  TextButton.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 28.8.2023.
//

import SwiftUI

struct TextButton: View {
    @Environment(\.isEnabled) private var isEnabled

    let text: String
    let theme: ButtonTheme
    let action: () -> Void
    
    enum ButtonTheme {
        case light(foregroundColor: Color = Color.init("textGray"), backgroundColor: Color = Color.white, borderColor: Color = Color.init("magenta"))
        case fill(foregroundColor: Color = Color.white, backgroundColor: Color = Color.init("magenta"), borderColor: Color = Color.gray)
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            switch theme {
            case .fill(let foregroundColor, let backgroundColor, let borderColor):
                Text(text)
                    .font(.system(size: 16))
                    .frame(minWidth: 130, minHeight: 42)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 21)
                            .fill(isEnabled ? backgroundColor : Color.clear)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 21)
                            .stroke(isEnabled ? Color.clear : borderColor, lineWidth: 2)
                    )
                    .foregroundColor(isEnabled ? foregroundColor : Color.gray)
            case .light(let foregroundColor, let backgroundColor, let borderColor):
                Text(text)
                    .font(.system(size: 16))
                    .frame(minWidth: 130, minHeight: 42)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 21)
                            .fill(isEnabled ? backgroundColor : Color.clear)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 21)
                            .stroke(isEnabled ? borderColor : Color.gray, lineWidth: 2)
                    )
                    .foregroundColor(foregroundColor)
            }
        }
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(text: "Continue Shopping", theme: .light(), action: {})
    }
}
