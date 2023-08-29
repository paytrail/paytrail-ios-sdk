//
//  AppCheckboxStyle.swift
//  paytrail-ios-sdk
//
//  Created by shiyuan on 29.8.2023.
//

import SwiftUI

struct AppCheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack(alignment: .top) {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .renderingMode(.template)
                    .foregroundColor(Color.black)
                    .padding(.top, 4)
                configuration.label
            }
        })
    }
}
