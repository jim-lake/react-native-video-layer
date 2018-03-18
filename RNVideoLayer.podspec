
Pod::Spec.new do |s|
  s.name         = "RNVideoLayer"
  s.version      = "1.0.1"
  s.summary      = "RNVideoLayer"
  s.description  = <<-DESC
                  React Native Video layer outside of view hierarchy
                   DESC
  s.homepage     = "https://github.com/jim-lake/react-native-video-layer"
  s.license      = "MIT"
  s.author       = { "author" => "jim@blueskylabs.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/jim-lake/react-native-video-layer.git", :tag => "master" }
  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"

end
