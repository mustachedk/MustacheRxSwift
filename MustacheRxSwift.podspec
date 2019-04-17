Pod::Spec.new do |s|
    s.name             = 'MustacheRxSwift'
    s.version          = '0.1.0'
    s.summary          = 'Helper methods used at Mustache when creating new apps.'
    s.homepage         = 'https://github.com/mustachedk/MustacheRxSwift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Tommy Sadiq Hinrichsen' => 'th@mustache.dk' }
    s.source           = { :git => 'https://github.com/mustachedk/MustacheRxSwift.git', :tag => s.version.to_s }
    s.swift_version = '5.0'

    s.ios.deployment_target = '11.0'

    s.source_files = 'MustacheRxSwift/Classes/**/*'

    s.frameworks = 'UIKit', 'AVFoundation', 'CoreLocation', 'MapKit'

    s.dependency 'RxSwift'
    s.dependency 'RxSwiftExt'

end
