#
#  Be sure to run `pod spec lint StashAnalytics.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "StashAnalytics"
  spec.version      = "0.0.3"
  spec.summary      = "Stash is a Simple and privacy-focused mobile analytics"
  spec.homepage = "http://usestash.com"
  spec.license = "MIT"
  spec.author = "Ciprian Redinciuc"

  spec.platform = :ios, "14.0"
  spec.ios.deployment_target = "14.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source = { :git => "https://github.com/usestash/stash-ios.git", :tag => "v#{spec.version}" }
  spec.source_files = "Sources"
  spec.swift_versions = ['5.0']
end
