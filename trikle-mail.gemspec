require './lib/triklemailer'

Gem::Specification.new do |s|
  s.name        = 'trikle-mail'
  s.version     = Triklemailer::VERSION
  s.date        = '2017-10-18'
  s.summary     = "Send a trickle of mail"
  s.description = "Send bulk email in a trickle over mandrill"
  s.authors     = ["Jasper Lyons"]
  s.email       = 'jasper.lyons@gmail.com'
  s.files       = ['lib/triklemailer.rb']
  s.executables << 'trikle-mail'
  s.homepage    = ''
  s.license       = 'MIT'

  s.add_dependency 'commander', '~> 4.4'
  s.add_dependency 'mandrill-api', '~> 1'
  s.add_dependency 'mail', '~> 2'

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'mail', '~> 2'
  s.add_development_dependency 'byebug'
end
