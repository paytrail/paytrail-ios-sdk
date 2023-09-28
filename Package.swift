// swift-tools-version:5.7.1

import PackageDescription

let package = Package(name: "paytrail-ios-sdk",
                      platforms: [.iOS(.v15)],
                      products: [
                          .library(
                              name: "paytrail-ios-sdk",
                              targets: ["paytrail-ios-sdk"])
                              ],
                      targets: [
                          .target(
                            name: "paytrail-ios-sdk",
                            path: "paytrail-ios-sdk"
                          ),
                          .testTarget(
                              name: "paytrail-ios-sdkTests",
                              dependencies: ["paytrail-ios-sdk"],
                              path: "paytrail-ios-sdkTests"
                              )],
                      swiftLanguageVersions: [.v5])
