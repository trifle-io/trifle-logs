# frozen_string_literal: true

require_relative 'lib/trifle/logs/version'

Gem::Specification.new do |spec|
  spec.name = 'trifle-logs'
  spec.version = Trifle::Logs::VERSION
  spec.authors = ['Jozef Vaclavik']
  spec.email = ['jozef@hey.com']

  spec.summary = "Simple log dumps and regexp search."
  spec.description = "Trifle::Logs is a way too simple log store with quick search on top of it"
  spec.homepage = 'https://trifle.io'
  spec.licenses = ['MIT']
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/trifle-io/trifle-logs'
  spec.metadata["changelog_uri"] = 'https://trifle.io/trifle-logs/changelog'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency('bundler', '~> 2.1')
  spec.add_development_dependency('byebug', '>= 0')
  spec.add_development_dependency('rspec', '~> 3.2')
  spec.add_development_dependency('rubocop', '1.0.0')
end
