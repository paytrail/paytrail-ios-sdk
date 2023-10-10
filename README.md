# paytrail-ios-sdk

## Introduction

Paytrail iOS SDK is basically made for the ease of any developer who wants to use the Paytrail [Web APIs](https://docs.paytrail.com/#/?id=paytrail-payment-api) in their native iOS project. The SDK encapsulates the major features of **create a normal payment**, **save a payment card token**, and **pay & add card**.

For the SDK's APIs guide, please check out [Paytrail iOS SDK Guide](paytrail-ios-sdk/paytrail_ios_sdk.docc/paytrail_ios_sdk_guide.md).

## Requirements

| Requirement | Minimal version |
| ------ | ------ |
| iOS | 15 |
| Swift | 5 |
| CocoaPods | 1.11.3 |

## Installation

### CocoaPods

Add the line below in your project's ``Podfile``

```
pod 'paytrail-ios-sdk', git: 'https://github.com/paytrail/paytrail-ios-sdk.git'
```

You can also *specify the branch* to install from

```
pod 'paytrail-ios-sdk', :git => 'https://github.com/paytrail/paytrail-ios-sdk.git', :branch => 'feature/documentation'
```

### Swift Package Manager

To add a Swift package dependency to your project, follow the [guide here](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).

**Package Lcation:**

```
https://github.com/paytrail/paytrail-ios-sdk.git
```
**Version Rules:**

```
Branch main
```

## Get Started

Before getting started with the SDK's APIs, a shared ``PaytrailMerchant`` should be created in the beginning when app launches in the, for example, ``AppDelegate``, or the `main app` in a SwiftUI app before any API is called. You can also turn on the SDK's debug logging for the ease of development.

```
import paytrail_ios_sdk

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ...
        PaytrailMerchant.create(merchantId: "YOUR_MERCHANT_ID", secret: "YOUR_MERCHANT_SECRET")
        PTLogger.globalLevel = .debug
        return true
    }
}
```

```
import SwiftUI
import paytrail_ios_sdk

@main
struct PaytrailSdkExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ShoppingCartView()
                .preferredColorScheme(.light)
                .onAppear {
                    PaytrailMerchant.create(merchantId: "YOUR_MERCHANT_ID", secret: "YOUR_MERCHANT_SECRET")
                    TLogger.globalLevel = .debug
                }
        }
    }
}
```

## Examples

[Paytrail SDK Examples](https://github.com/paytrail/paytrail-ios-sdk/tree/main/PaytrailSdkExamples) app provides the detailed examples for the usages of the SDK's APIs.

## License

Payrail iOS SDK is released under [MIT License](https://github.com/paytrail/paytrail-ios-sdk/blob/main/LICENSE)


