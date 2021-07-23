#
#  Be sure to run `pod spec lint StashAnalytics.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "StashAnalytics"
  spec.version      = "0.0.1"
  spec.summary      = "Stash is a Simple and privacy-focused mobile analytics"
  spec.homepage = "http://getstash.com"
  spec.license = "MIT"
  spec.author = "Ciprian Redinciuc"

  spec.platform = :ios, "13.0"
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source = { :git => "https://github.com/usestash/stash.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources"
end
