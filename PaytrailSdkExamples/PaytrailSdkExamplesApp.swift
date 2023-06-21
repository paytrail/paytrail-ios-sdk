//
//  PaytrailSdkExamplesApp.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI

@main
struct PaytrailSdkExamplesApp: App {
    var isAddingCard: Bool = true
    var body: some Scene {
        WindowGroup {
            if !isAddingCard {
                ContentView()
            } else {
                AddCardView()
            }
        }
    }
}
