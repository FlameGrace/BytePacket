#
#  Be sure to run `pod spec lint BytePacket.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "BytePacket"
  s.version      = "0.0.5"
  s.summary      = "A byte decode tool for iOS."
  s.homepage     = "https://github.com/FlameGrace/BytePacket"
  s.license      = "BSD"
  s.author             = { "FlameGrace" => "flamegrace@hotmail.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/FlameGrace/BytePacket.git", :tag => "0.0.5" }
  s.source_files  = "BytePacket", "BytePacket/**/*.{h,m}"
  s.public_header_files = "BytePacket/**/*.h"
end
