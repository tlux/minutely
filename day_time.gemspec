# frozen_string_literal: true

require_relative 'lib/day_time/version'

Gem::Specification.new do |spec|
  spec.name = 'day_time'
  spec.version = DayTime::VERSION
  spec.authors = ['Tobias Casper']
  spec.email = ['tobias.casper@gmail.com']

  spec.summary = 'Classes for representing the time of a day by using only hours and minutes'
  spec.homepage = 'https://gitlab.i22.de/pakete/ruby/day_time'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'http://gems.dev.i22.de'
  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
