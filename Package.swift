import PackageDescription

let package = Package(name: "paytrail-ios-sdk",
                      platforms: [.iOS(.v15_4)],
                      products: [
                          .library(
                              name: "paytrail-ios-sdk",
                              targets: ["paytrail-ios-sdk"])
                              ],
                      targets: [
                          .target(name: "paytrail-ios-sdk"),
                          .testTarget(
                              name: "paytrail-ios-sdkTests",
                              dependencies: ["paytrail-ios-sdk"]
                              )],
                      swiftLanguageVersions: [.v5])