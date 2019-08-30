Pod::Spec.new do |s|
    s.name             = 'MustacheRxSwift'
    s.version          = '0.3.3'
    s.summary          = 'Helper methods used at Mustache when creating new apps.'
    s.homepage         = 'https://github.com/mustachedk/MustacheRxSwift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Tommy Sadiq Hinrichsen' => 'th@mustache.dk' }
    s.source           = { :git => 'https://github.com/mustachedk/MustacheRxSwift.git', :tag => s.version.to_s }
    s.swift_version = '5.0'

    s.ios.deployment_target = '11.0'

    s.source_files = 'MustacheRxSwift/Classes/**/*.swift'

    s.frameworks = 'UIKit', 'AVFoundation', 'CoreLocation', 'MapKit', 'UserNotifications'

    s.dependency 'RxSwift'
    s.dependency 'RxSwiftExt'
    s.dependency 'RxViewController'
    s.dependency 'MustacheServices'
    s.dependency 'MustacheUIKit'

end
