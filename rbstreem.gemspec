require File.expand_path("../lib/rbstreem/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'rbstreem'
  s.version     = '0.0.0'
  s.date        = '2016-06-12'
  s.summary     = "Try to implement matz/streem as a DSL within Ruby with a little syntax sacrifice."
  s.description = "Try to implement matz/streem as a DSL within Ruby with a little syntax sacrifice."
  s.authors     = ["DeathKing"]
  s.email       = 'deathking0622@gmail.com'
  s.homepage    = 'https://github.com/DeathKing/streem.rb'

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  s.executables = ["streem"]
  s.license       = 'MIT'
end