Gem::Specification.new do |s|
  s.name        = 'open-nhl'
  s.version     = '0.0.1'
  s.date        = '2016-04-28'
  s.summary     = "Parses NHL HTML reports"
  s.description = "A simple gem to parse NHL HTML reports"
  s.authors     = ["Ivan Mironov"]
  s.email       = 'ivan.mironov@gmail.com'
  s.files       = ['lib/open-nhl.rb', 'lib/parser.rb', 'lib/fetcher.rb']
  s.homepage    = 'https://github.com/emzar/open-nhl'
  s.license     = 'MIT'
  s.add_runtime_dependency 'nokogiri', '>= 1.6.7.2'
  s.add_development_dependency 'nokogiri', '>= 1.6.7.2'
end
