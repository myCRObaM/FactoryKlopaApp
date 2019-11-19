platform :ios, '11.0'
use_frameworks!
workspace 'FactoryApp'

def pods
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SnapKit'
  pod 'Hue'
end

def testing_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'Cuckoo', '1.2.0'
  pod 'RxTest'
end



target 'FactoryApp' do
  pods
end

target 'FactoryAppTests' do
  testing_pods
end

target 'Shared' do
  project 'Shared/Shared.project'
  pods
  target 'SharedTests' do
    testing_pods
  end
end

target 'MealsScreen' do
  project 'MealsScreen/MealsScreen.project'
  pods
  target 'MealsScreenTests' do
    testing_pods
  end
end

target 'RestorauntsSingle' do
  project 'RestorauntsSingle/RestorauntsSingle.project'
  pods
  target 'RestorauntsSingleTests' do
    testing_pods
  end
end

