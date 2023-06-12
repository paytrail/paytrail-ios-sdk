//
//  BackButton.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 12.6.2023.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
        }
    }

}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(action: {})
    }
}
