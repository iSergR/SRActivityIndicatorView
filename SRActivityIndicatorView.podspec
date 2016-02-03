Pod::Spec.new do |s|
  s.name         = "SRActivityIndicatorView"
  s.version      = "0.0.3"
  s.summary      = "nice indicator view - SRActivityIndicatorView."
  s.description  = "nice indicator view - SRActivityIndicatorView. Indicator for process loading "
  s.homepage     = "https://github.com/iSergR/SRActivityIndicatorView"
  s.license      = "MIT"
  s.author             = { "Sergey Rudenko" => "serg.rudenko@owlylabs.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/iSergR/SRActivityIndicatorView.git", :tag => "0.0.3" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true
end
