require_relative 'lib/hidden_hooks/version'

Gem::Specification.new do |spec|
  spec.name = 'hidden_hooks'
  spec.version = HiddenHooks::VERSION
  spec.authors = ['Moku S.r.l.', 'Riccardo Agatea']
  spec.email = ['info@moku.io']
  spec.license = 'MIT'

  spec.summary = 'A way to defer hooks to reduce dependencies.'
  spec.description = 'Sometimes we need callbacks that break dependencies. This gem allows to invert those ' \
                     'dependencies.'
  spec.homepage = 'https://github.com/moku-io/hidden_hooks'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/moku-io/hidden_hooks'
  spec.metadata['changelog_uri'] = 'https://github.com/moku-io/hidden_hooks/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir __dir__ do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
end
