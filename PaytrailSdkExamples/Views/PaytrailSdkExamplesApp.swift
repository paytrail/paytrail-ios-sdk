//
//  PaytrailSdkExamplesApp.swift
//  PaytrailSdkExamples
//
//  Created by shiyuan on 30.5.2023.
//

import SwiftUI

@main
struct PaytrailSdkExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ShoppingCartView()
                .preferredColorScheme(.light)
                .onAppear {
                    PTLogger.globalLevel = .debug
                    // 375917
                    PaytrailMerchant.create(merchantId: "375917", secret: "SAIPPUAKAUPPIAS")
                }
        }
    }
}
