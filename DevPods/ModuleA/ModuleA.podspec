#
# Be sure to run `pod lib lint ModuleA.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ModuleA'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ModuleA.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/张泽中/ModuleA'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '张泽中' => '16664476+zzz1029335886@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/张泽中/ModuleA.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ModuleA/Module/**/*.{swift}'
  s.resources = "ModuleA/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld,pdf}"

#   s.resource_bundles = {
#     'ModuleA' => ['ModuleA/Module/**/*.png']
#   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Networking'
  s.dependency 'Base'
  s.dependency 'Common'
  s.dependency 'JXPhotoBrowser', '~> 3.1.3'
  
end
