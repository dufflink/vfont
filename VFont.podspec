Pod::Spec.new do |s|
  s.name = 'VFont'
  s.version = '0.5.0'

  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.summary = 'Variable Fonts in Swift and SwiftUI'

  s.homepage = 'https://github.com/dufflink/vfont'
  s.authors = { 'Maxim Skorynin from Evil Martians' => 'skoryninmaksim1@gamil.com' }
  
  s.source = { :git => 'https://github.com/dufflink/vfont.git', :tag => s.version }
  s.documentation_url = 'https://github.com/dufflink/vfont'

  s.ios.deployment_target = '11.0'

  s.swift_versions = '5.0'
  s.source_files = 'Source/Framework'
end
