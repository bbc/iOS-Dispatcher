Pod::Spec.new do |s|
  s.name         = "MultiplexDispatcher"
  s.version      = "0.0.1"
  s.summary      = "Message multiplexing component that aids in reducing boilerplate when implementing the observer pattern within your iOS application."
  s.homepage     = "https://github.com/bbc/MultiplexDispatcher"
  s.license      = { :type => 'None', :file => "LICENSE" }
  s.author             = { "ThomasSherwoodBBC" => "thomas.sherwood@bbc.co.uk" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/bbc/MultiplexDispatcher.git", :tag => "#{s.version}" }
  
  s.public_header_files = "MultiplexDispatcher/Public/**/*.h"
  s.framework  = "Foundation"
  
  s.subspec 'Objective-C' do |ss|
      ss.source_files  = "MultiplexDispatcher/**/*.{h,m}"
  end
  
  s.subspec 'Swift' do |ss|
      ss.source_files = "MultiplexDispatcher/**/*.{h,m,swift}"
  end
  
end
