# frozen_string_literal: true

require_relative "lib/rubocop/lsp/version"

Gem::Specification.new do |spec|
  spec.name          = "rubocop-lsp"
  spec.version       = Rubocop::Lsp::VERSION
  spec.authors       = ["Shopify"]
  spec.email         = ["ruby@shopify.com"]

  spec.summary       = "A Language Server Provider for RuboCop"
  spec.homepage      = "https://github.com/Shopify/rubocop-lsp"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Shopify/rubocop-lsp"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    %x(git ls-files -z).split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency("rubocop", ">= 1.0")
  spec.add_dependency("language_server-protocol", ">= 3.16")
end
