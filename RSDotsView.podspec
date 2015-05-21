Pod::Spec.new do |s|
  s.name     = 'RSDotsView'
  s.version  = '1.0'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = 'A simple view that show pulsing dots'
  s.homepage = 'https://github.com/Kemcake/RSDotsView'
  s.author   = { 'Rémi Santos' => 'santos.remi@icloud.com' }
  s.source   = { :git => 'https://github.com/Kemcake/RSDotsView.git', :tag => s.version.to_s }
  s.source_files = 'RSDotsView/*'
  s.requires_arc = true
end
