require File.expand_path("../lib/rbstreem/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'rbstreem'
  s.version     = '0.0.0'
  s.date        = '2016-06-12'
  s.summary     = "RbStreem"
  s.description = "RbStreem"
  s.authors     = ["DeathKing"]
  s.email       = 'deathking0622@gmail.com'
 # s.homepage    =   'http://rubygems.org/gems/hola'

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  s.executables = ["streem"]
  s.license       = 'MIT'
end