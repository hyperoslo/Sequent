Pod::Spec.new do |s|
  s.name             = "Sequent"
  s.summary          = "Sequent iOS Framework."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/hyperoslo/Sequent"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = {
    :git => "https://github.com/hyperoslo/Sequent.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.2'

  s.requires_arc = true
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.tvos.source_files = 'Sources/{iOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{Mac,Shared}/**/*'

  s.ios.frameworks = 'UIKit', 'Foundation'
  s.osx.frameworks = 'Cocoa', 'Foundation'

  s.dependency 'Spots'
  s.dependency 'Compass'
  s.dependency 'Malibu'
  s.dependency 'RxSwift'
  s.dependency 'ReSwift'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
