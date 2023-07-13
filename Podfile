# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

inhibit_all_warnings!

target 'DrinkWhat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DrinkWhat
    pod 'SwiftLint'
    pod 'LineSDKSwift', '~> 5.0'
    pod 'FirebaseAuth', '~> 10.0.0'
    pod 'FirebaseFirestore', '~> 10.11.0'
    pod 'FirebaseFirestoreSwift', '~> 10.11.0'
    pod 'FirebaseStorage'
    pod 'Kingfisher'
    pod 'Toast-Swift'
    pod 'IQKeyboardManagerSwift'
    pod 'FirebaseCrashlytics'
    pod 'FirebaseAnalytics'

    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
          config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
          config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
        end
      end
    end
end
