#
# Be sure to run `pod lib lint ModuleManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ModuleManager'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ModuleManager.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zzz1029335886/ModuleManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zzz1029335886' => 'zzz1029335886@qq.com' }
  s.source           = { :git => 'https://github.com/zzz1029335886/ModuleManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ModuleManager/Module/**/*.{swift}'
  s.resources = "ModuleManager/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld,pdf}"
  
  # s.resource_bundles = {
  #   'ModuleManager' => ['ModuleManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ModuleA'
  s.dependency 'ModuleB'
  
end
