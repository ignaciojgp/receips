# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Receips' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!



pod 'TesseractOCRiOS', '4.0.0'
post_install do |installer|
    puts 'Removing static analyzer support'
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['OTHER_CFLAGS'] = "$(inherited) -Qunused-arguments -Xanalyzer -analyzer-disable-all-checks"

        end
    end
end
  # Pods for Receips
  

  target 'ReceipsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ReceipsUITests' do
    inherit! :search_paths
    # Pods for testing
  end


end
