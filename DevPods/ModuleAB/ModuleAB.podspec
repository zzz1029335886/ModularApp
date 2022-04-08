#
# Be sure to run `pod lib lint ModuleAB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ModuleAB'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ModuleAB.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zzz1029335886/ModuleAB'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zzz1029335886' => '16664476+zzz1029335886@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/zzz1029335886/ModuleAB.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ModuleAB/Module/**/*.{swift}'
  s.resources = "ModuleAB/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}"

  # s.resource_bundles = {
  #   'ModuleAB' => ['ModuleAB/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'ModuleA'
   s.dependency 'ModuleB'
   s.dependency 'Base'
   s.dependency 'Common'
   s.dependency 'Networking'
end
