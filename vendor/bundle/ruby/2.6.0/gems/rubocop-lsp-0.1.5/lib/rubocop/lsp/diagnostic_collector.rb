# frozen_string_literal: true

require "rubocop/lsp/model/diagnostic_collection"

class DiagnosticCollector < RuboCop::Runner
  RUBOCOP_FLAGS = [
    "--stderr", # Print any output to stderr so that our stdout does not get polluted
    "--format",
    "quiet", # Supress any progress output by setting the formatter to `quiet`
    "--auto-correct", # Apply the autocorrects on the supplied buffer
  ]

  attr_reader :uri, :file, :text, :formatted_text, :diagnostics

  def initialize(uri:, text:)
    @uri = uri
    @file = CGI.unescape(URI.parse(uri).path)
    @text = text
    @formatted_text = nil

    super(
      ::RuboCop::Options.new.parse(RUBOCOP_FLAGS).first,
      ::RuboCop::ConfigStore.new
    )
  end

  def run
    # Send text via "stdin".
    # RuboCop reads all of stdin into the "stdin" option, when `--stdin`
    # flag is supplied
    @options[:stdin] = text

    # Invoke the actual run method with just this file in `paths`
    super([file])

    # RuboCop applies autocorrections to the "stdin" option,
    # so read that into the formatted text attribute
    @formatted_text = @options[:stdin]
  end

  def file_finished(_file, offenses)
    @diagnostics = Model::DiagnosticCollection.new(uri, offenses)
  end
end
