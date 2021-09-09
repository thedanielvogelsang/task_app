# -*- encoding: utf-8 -*-
# stub: rubocop-lsp 0.1.5 ruby lib

Gem::Specification.new do |s|
  s.name = "rubocop-lsp".freeze
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "homepage_uri" => "https://github.com/Shopify/rubocop-lsp", "source_code_uri" => "https://github.com/Shopify/rubocop-lsp" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Shopify".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-08-05"
  s.email = ["ruby@shopify.com".freeze]
  s.executables = ["rubocop-lsp".freeze]
  s.files = ["exe/rubocop-lsp".freeze]
  s.homepage = "https://github.com/Shopify/rubocop-lsp".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A Language Server Provider for RuboCop".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubocop>.freeze, [">= 1.0"])
      s.add_runtime_dependency(%q<language_server-protocol>.freeze, [">= 3.16"])
    else
      s.add_dependency(%q<rubocop>.freeze, [">= 1.0"])
      s.add_dependency(%q<language_server-protocol>.freeze, [">= 3.16"])
    end
  else
    s.add_dependency(%q<rubocop>.freeze, [">= 1.0"])
    s.add_dependency(%q<language_server-protocol>.freeze, [">= 3.16"])
  end
end
