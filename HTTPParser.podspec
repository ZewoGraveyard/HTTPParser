Pod::Spec.new do |s|
  s.name = 'HTTPParser'
  s.version = '0.1'
  s.license = 'MIT'
  s.summary = 'HTTP parser for Swift 2 (Linux ready)'
  s.homepage = 'https://github.com/Zewo/HTTPParser'
  s.authors = { 'Paulo Faria' => 'paulo.faria.rl@gmail.com' }
  s.source = { :git => 'https://github.com/Zewo/HTTPParser.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Dependencies/Incandescence/*.c', 'HTTPParser/**/*.swift'

  s.xcconfig =  {
    'SWIFT_INCLUDE_PATHS' => '$(SRCROOT)/HTTPParser/Dependencies'
  }

  s.preserve_paths = 'Dependencies/*'
  s.dependency 'HTTP'

  s.requires_arc = true
end