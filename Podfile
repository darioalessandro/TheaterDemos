# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'
# pod trunk push Theater.podspec --allow-warnings 

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

def protobuf
    pod 'SwiftProtobuf', '~> 1.0'
end

def gallery
    pod 'BFGallery' , :git => "https://github.com/darioalessandro/BlackFireGallery.git", :tag => "0.1.5"
end

def testing_pods
    pod 'Quick', '~> 1.3.2'
    pod 'Nimble', '7.3.1'
end

target 'ActorsDemo' do
    pod 'Starscream', '~> 3.0.6'
    pod 'Theater', '~> 0.9.1'
    gallery
    protobuf
end

target 'RemoteCam' do
    pod 'Starscream', '~> 3.0.6'
    pod 'Theater', '~> 0.9.1'
    pod 'SwiftProtobuf', '~> 1.0'
    gallery
    protobuf
end

target 'RemoteCamTests' do
    pod 'Starscream', '~> 3.0.6'
    pod 'Theater', '~> 0.9.1'
    pod 'SwiftProtobuf', '~> 1.0'
    gallery
    protobuf
    testing_pods
end

target 'ActorsTests' do
    pod 'Starscream', '~> 3.0.6'
    pod 'Theater', '~> 0.9.1'
    testing_pods
    gallery
    protobuf
end


