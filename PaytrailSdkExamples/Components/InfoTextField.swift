//
//  InfoTextField.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct InfoTextField: View {
    
    let placeholder: String
    @Binding var text: String
    let onTextUpdated: () -> Void
    
    @State private var isFocused: Bool = false
    private let focusedColor: Color = Color.init("magenta")
    private let unfocusedColor: Color = Color.init("appGray")
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .top) {
                TextField(placeholder, text: $text, onEditingChanged: { focused in
                    print("text view focused: \(focused)")
                    isFocused = focused
                    onTextUpdated()
                })
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                    )
                    .foregroundColor(Color.black)

                HStack {
                    Text(placeholder)
                        .font(.system(size: 12))
                        .foregroundColor(!text.isEmpty || isFocused ? focusedColor : Color.clear)
                        .padding(.leading, 18)
                        .padding(.top, 2)
                    Spacer()
                }
            }
            VStack {
                Divider()
                    .frame(minHeight: 3)
                    .overlay(isFocused ? focusedColor : unfocusedColor)
            }
        }
    }
}

struct InfoTextField_Previews: PreviewProvider {
    static var previews: some View {
        InfoTextField(placeholder: "First name", text: .constant(""), onTextUpdated: {})
    }
}
