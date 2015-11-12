Pod::Spec.new do |s|
  s.name = 'Luminescence'
  s.version = '0.1'
  s.license = 'MIT'
  s.summary = 'HTTP parser for Swift 2 (Linux ready)'
  s.homepage = 'https://github.com/Zewo/Kalopsia'
  s.authors = { 'Paulo Faria' => 'paulo.faria.rl@gmail.com' }
  s.source = { :git => 'https://github.com/Zewo/Luminescence.git', :tag => 'v0.1' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Dependencies/Incandescence/*.c', 'Luminescence/**/*.swift'

  s.xcconfig =  {
    'SWIFT_INCLUDE_PATHS' => '$(SRCROOT)/Luminescence/Dependencies'
  }

  s.preserve_paths = 'Dependencies/*'

  s.requires_arc = true
end