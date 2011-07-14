require "./lib/rubylude.rb"

Gem::Specification.new do |s|
  s.name             = "rubylude"
  s.version          = Rubylude::VERSION
  s.date             = Time.now.utc.strftime("%Y-%m-%d")
  s.homepage         = "http://github.com/nono/rubylude"
  s.authors          = "Bruno Michel"
  s.email            = "bruno.michel@af83.com"
  s.description      = "Rubylude is a port of Perlude to Ruby 1.9"
  s.summary          = s.description
  s.extra_rdoc_files = %w(README.md)
  s.files            = Dir["MIT-LICENSE", "README.md", "Gemfile", "lib/**/*.rb"]
  s.require_paths    = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.add_development_dependency "minitest", "~>2.3"
end
