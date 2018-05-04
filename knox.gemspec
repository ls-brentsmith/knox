$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'knox/version'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.name = 'knox'
  s.version = Knox::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = 'Automating the mounting of secrets from Vault'
  s.description = 'Automating the mounting of secrets from Vault'
  s.homepage = 'https://github.com/ls-bsmith/knox.git'
  s.author = 'Brent Smith'
  s.email = 'brent.smith@lightspeedretail.com'
  s.license = 'private'

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'vault', '0.9.0'
  s.add_dependency 'json', '2.1.0'

  s.bindir       = 'bin'
  s.executables  = %w(knox)

  s.require_paths = %w(lib lib/knox)
  s.files         = Dir.glob('{bin,lib}/**/*') + %w(README.md CHANGELOG.md VERSION)
  s.test_files    = Dir.glob('{test,spec,features}/**/*')
end
