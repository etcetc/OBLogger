#
# Be sure to run `pod lib lint OBLogger.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "OBLogger"
  s.version          = "0.11"
  s.summary          = "A simple logging utility"
  s.description      = <<-DESC
                       This provides some simple macros for logging debug,
info, warn, and error messages.  The messages are written to a log file.  The
log file can then be viewed via an included viewController, or retrieved.

DESC

  s.homepage         = "https://github.com/etcetc/OBLogger"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "etcetc" => "ff@onebeat.com" }
  s.source           = { :git => "https://github.com/etcetc/OBLogger.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.xib'

  s.public_header_files = 'Pod/Classes/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
