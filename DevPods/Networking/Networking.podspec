Pod::Spec.new do |s|
  s.name             = 'Networking'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Networking.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/张泽中/Networking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张泽中' => '16664476+zzz1029335886@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/张泽中/Networking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Networking/Module/**/*.{swift}'
  s.resources = "Networking/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}"
  
  # s.resource_bundles = {
  #   'Networking' => ['Networking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'HandyJSON', '~> 5.0.2'
  s.dependency 'Alamofire', '~> 4.9.1'
end
