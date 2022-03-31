platform :ios, '10.0'

workspace 'App.xcworkspace'
project 'App.xcodeproj'

def networking_pod
  pod 'Networking', :path => 'DevPods/Networking'
end

def module_a_pod
  pod 'ModuleA', :path => 'DevPods/ModuleA'
end

def base_pod
  pod 'Base', :path => 'DevPods/Base'
end

def common_pod
  pod 'Common', :path => 'DevPods/Common'
end

def development_pods
  networking_pod
  module_a_pod
  base_pod
  common_pod
end

target 'App' do
  use_frameworks!
  # Pods for App
  development_pods
end

target 'Networking_Example' do
  use_frameworks!
  project 'DevPods/Networking/Example/Networking.xcodeproj'
  
  networking_pod
end

target 'ModuleA_Example' do
  use_frameworks!
  project 'DevPods/ModuleA/Example/ModuleA.xcodeproj'
  
  module_a_pod
end

target 'Base_Example' do
  use_frameworks!
  project 'DevPods/Base/Example/Base.xcodeproj'
  
  base_pod
end

target 'Common_Example' do
  use_frameworks!
  project 'DevPods/Common/Example/Common.xcodeproj'
  
  common_pod
end


