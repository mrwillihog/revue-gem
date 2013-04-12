Gem::Specification.new do |s|
  s.name        = 'revue'
  s.version     = '1.0.1'
  s.date        = '2013-04-02'
  s.summary     = "Command line tool for accessing http://revue.io"
  s.description = "A gem for creating and fetching code reviews via the revue.io website"
  s.authors     = ["Matthew Williams"]
  s.email       = 'm.williams@me.com'
  s.files       = ["lib/revue.rb"]
  s.executables << 'revue'
  s.add_dependency "rest-client", "~> 1.6.7"
  s.add_dependency "trollop", "~> 2.0"
  s.homepage    =
    'http://rubygems.org/gems/revue'
end