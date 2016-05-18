Pod::Spec.new do |s|
  s.name         = "Dispatcher"
  s.version      = "0.0.1"
  s.summary      = "Message multiplexing component that aids in reducing boilerplate when implementing the observer pattern within your iOS application."
  s.homepage     = "https://github.com/bbc/Dispatcher"
  s.license      = { :type => 'None', :file => "LICENSE" }
  s.author             = { "ThomasSherwoodBBC" => "thomas.sherwood@bbc.co.uk" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/bbc/Dispatcher.git", :tag => "#{s.version}" }
  s.framework  = "Foundation"
  
  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  
  s.subspec 'Objective-C' do |ss|
      ss.source_files  = "Dispatcher/Public/**/*.h", "Dispatcher/**/*.{h,m}"
  end
  
  s.subspec 'Swift' do |ss|
      ss.source_files = "Dispatcher/**/*.{h,m,swift}"
  end
  
end
