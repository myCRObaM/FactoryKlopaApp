# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

workspace 'FactoryApp'

def pods
pod 'Alamofire'
pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SnapKit'
pod 'Hue'
end

def testing_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'Cuckoo'
  pod 'RxTest'
end



target 'FactoryApp' do
pods
  target 'FactoryAppTests' do
    inherit! :search_paths
    testing_pods
  end
end

target 'Shared' do
  project 'Shared/Shared.project'
pods
  target 'SharedTests' do
    inherit! :search_paths
    testing_pods
  end
end

target 'MealsScreen' do
  project 'MealsScreen/MealsScreen.project'
pods
  target 'MealsScreenTests' do
    inherit! :search_paths
    testing_pods
  end
end
