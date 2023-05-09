platform :ios, '10.0'

workspace 'App.xcworkspace'
project 'App.xcodeproj'

def networking_pod
  pod 'Networking', :path => 'DevPods/Networking'
end

def module_a_pod
  pod 'ModuleA', :path => 'DevPods/ModuleA'
end

def module_b_pod
  pod 'ModuleB', :path => 'DevPods/ModuleB'
end

def module_ab_pod
  pod 'ModuleAB', :path => 'DevPods/ModuleAB'
end

def module_component_pod
  pod 'Component', :path => 'DevPods/Component'
end

def base_pod
  pod 'Base', :path => 'DevPods/Base'
end

def common_pod
  pod 'Common', :path => 'DevPods/Common'
end

def module_manager_pod
    pod 'ModuleManager', :path => 'DevPods/ModuleManager'
end

def module_run_pod
    pod 'ModuleRun', :path => 'DevPods/ModuleRun'
end

def development_pods
  networking_pod
  module_a_pod
  module_b_pod
  base_pod
  common_pod
  module_ab_pod
  module_component_pod
  module_manager_pod
  module_run_pod
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

target 'ModuleB_Example' do
  use_frameworks!
  project 'DevPods/ModuleB/Example/ModuleB.xcodeproj'
  
  module_b_pod
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

target 'ModuleAB_Example' do
  use_frameworks!
  project 'DevPods/ModuleAB/Example/ModuleAB.xcodeproj'
  
  module_ab_pod
end

target 'Component_Example' do
  use_frameworks!
  project 'DevPods/Component/Example/Component.xcodeproj'
  
  module_component_pod
end

target 'ModuleManager_Example' do
  use_frameworks!
  project 'DevPods/ModuleManager/Example/ModuleManager.xcodeproj'
  
  module_manager_pod
end

target 'ModuleRun_Example' do
  use_frameworks!
  project 'DevPods/ModuleRun/Example/ModuleRun.xcodeproj'
  
  module_run_pod
end

