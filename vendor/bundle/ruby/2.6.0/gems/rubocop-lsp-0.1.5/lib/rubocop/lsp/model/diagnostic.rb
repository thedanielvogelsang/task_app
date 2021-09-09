# frozen_string_literal: true

module Model
  class Diagnostic
    attr_reader :badge, :message, :start, :end, :replacements

    DOCS_URLS = {
      "Bundler":          "https://docs.rubocop.org/rubocop/cops_bundler.html#%{anchor}",
      "Gemspec":          "https://docs.rubocop.org/rubocop/cops_gemspec.html#%{anchor}",
      "Layout":           "https://docs.rubocop.org/rubocop/cops_layout.html#%{anchor}",
      "Lint":             "https://docs.rubocop.org/rubocop/cops_lint.html#%{anchor}",
      "Metrics":          "https://docs.rubocop.org/rubocop/cops_metrics.html#%{anchor}",
      "Migration":        "https://docs.rubocop.org/rubocop/cops_migration.html#%{anchor}",
      "Naming":           "https://docs.rubocop.org/rubocop/cops_naming.html#%{anchor}",
      "Security":         "https://docs.rubocop.org/rubocop/cops_security.html#%{anchor}",
      "Style":            "https://docs.rubocop.org/rubocop/cops_style.html#%{anchor}",
      "Minitest":         "https://docs.rubocop.org/rubocop-minitest/cops_minitest.html#%{anchor}",
      "Performance":      "https://docs.rubocop.org/rubocop-performance/cops_performance.html#%{anchor}",
      "Rails":            "https://docs.rubocop.org/rubocop-rails/cops_rails.html#%{anchor}",
      "RSpec":            "https://docs.rubocop.org/rubocop-rspec/cops_rspec.html#%{anchor}",
      "RSpec/Capybara":   "https://docs.rubocop.org/rubocop-rspec/cops_rspec/capybara.html#%{anchor}",
      "RSpec/FactoryBot": "https://docs.rubocop.org/rubocop-rspec/cops_rspec/factorybot.html#%{anchor}",
      "RSpec/Rails":      "https://docs.rubocop.org/rubocop-rspec/cops_rspec/rails.html#%{anchor}",
      "Sorbet":           "https://github.com/Shopify/rubocop-sorbet/blob/master/manual/cops_sorbet.md#%{anchor}",
    }

    def initialize(offense)
      @badge = RuboCop::Cop::Badge.parse(offense.cop_name)
      @message = offense.message
      @start = Interface::Position.new(line: offense.line - 1, character: offense.column)
      @end = Interface::Position.new(line: offense.last_line - 1, character: offense.last_column)
      @replacements = replacements_from_offense(offense)
    end

    def correctable?
      !!@replacements
    end

    def cop_name
      @cop_name ||= badge.to_s
    end

    def diagnostic_response
      @diagnostic_response ||= Interface::Diagnostic.new(
        message: message,
        "source": "RuboCop",
        code: cop_name,
        code_description: Interface::CodeDescription.new(
          href: doc_url
        ),
        severity: Constant::DiagnosticSeverity::INFORMATION,
        range: Interface::Range.new(
          start: start,
          end: self.end
        )
      )
    end

    private

    def doc_url
      @doc_url ||= begin
        anchor = cop_name.downcase.gsub(%r{/}, "")

        format(DOCS_URLS[badge.department], anchor: anchor)
      end
    end

    def replacements_from_offense(offense)
      return unless offense.correctable?

      offense.corrector.as_replacements.map do |range, replacement|
        edit_from_replacement(range, replacement)
      end
    end

    def edit_from_replacement(range, replacement)
      Interface::TextEdit.new(
        range: Interface::Range.new(
          start: Interface::Position.new(line: range.line - 1, character: range.column),
          end: Interface::Position.new(line: range.last_line - 1, character: range.last_column)
        ),
        new_text: replacement
      )
    end
  end
end
