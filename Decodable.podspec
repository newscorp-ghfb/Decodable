Pod::Spec.new do |s|
  s.name             = 'Decodable'
  s.version          = '0.7.0'
  s.summary          = 'Swift JSON parsing done (more) right'
  s.description      = 'Simple yet powerful object mapping made possible by Swift 2\'s error handling. Greatly inspired by Argo, but without any functional programming and bizillion operators.'
  s.homepage         = 'https://github.com/Anviking/Decodable'
  s.license          = 'MIT'
  s.author           = {
    'Anviking' => 'anviking@me.com',
    'Joe Mattiello' => 'jmattiello@newscorp.com'
  }
  s.source           = {
    :git => 'https://github.com/newscorp-ghfb/Decodable.git',
    :tag => s.version.to_s
  }

  s.swift_versions = ['4.2', '5.0']
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true
  s.source_files = 'Sources/*.{swift,h}'
end
