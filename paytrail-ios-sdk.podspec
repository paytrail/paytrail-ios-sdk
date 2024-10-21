Pod::Spec.new do |spec|

  spec.name         = "paytrail-ios-sdk"
  spec.version      = "1.0.0-beta4"
  spec.summary      = "Paytrail Mobile SDK for iOS"
  spec.description  = <<-DESC
  Paytrail iOS SDK providing the major payment features for easy mobile payments.
                   DESC
  spec.homepage     = "https://github.com/paytrail/paytrail-ios-sdk"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "shiyuan" => "shiyuan.wang@qvik.fi" }

  spec.platform     = :ios
  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = "15.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/paytrail/paytrail-ios-sdk.git", :tag => "#{spec.version}" }

  spec.source_files  = "paytrail-ios-sdk", "paytrail-ios-sdk/**/*.{h,m,swift}"

end
