# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'SwiftyJSON', '~> 5.0.1'
  pod 'UICircularProgressRing'
  pod 'Eureka'
end
target 'MQF' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
shared_pods

  # Pods for MQF

  target 'MQFTests' do
    inherit! :search_paths
    # Pods for testing
    shared_pods
  end

  target 'MQFUITests' do
    inherit! :search_paths
    # Pods for testing
    shared_pods
  end

end