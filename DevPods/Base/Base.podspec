#
# Be sure to run `pod lib lint Base.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Base'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Base.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/张泽中/Base'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张泽中' => '16664476+zzz1029335886@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/张泽中/Base.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '10.0'

  s.source_files = 'Base/Module/**/*.{swift}'
  s.resources = "Base/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}"
  
  # s.resource_bundles = {
  #   'Base' => ['Base/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'TZImagePickerController', '~> 3.7.6'
  s.dependency 'MBProgressHUD', '~> 1.2.0'
  s.dependency 'JXPhotoBrowser', '~> 3.1.3'
  s.dependency 'SnapKit'
  s.dependency 'Common'
end
