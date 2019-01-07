# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'
# pod trunk push Theater.podspec --allow-warnings 

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!



def gallery
    pod 'BFGallery' , :git => "https://github.com/darioalessandro/BlackFireGallery.git", :tag => "0.1.5"
end

def testing_pods
    pod 'Quick', '~> 1.3.2'
    pod 'Nimble', '7.3.1'
end

target 'ActorsDemo' do
    pod 'Starscream', '~> 3.0.6'
    pod 'Theater', :git => 'git@github.com:darioalessandro/Theater.git', :branch => "fix-visibility"
    gallery
end

target 'RemoteCam' do
    gallery    
    pod 'Starscream', '~> 3.0.6'
    pod 'Theater', :git => 'git@github.com:darioalessandro/Theater.git', :branch => "fix-visibility"
end

target 'ActorsTests' do
    pod 'Starscream', '~> 3.0.6'
    pod 'Theater', :git => 'git@github.com:darioalessandro/Theater.git', :branch => "fix-visibility"
    testing_pods
    gallery    
end


