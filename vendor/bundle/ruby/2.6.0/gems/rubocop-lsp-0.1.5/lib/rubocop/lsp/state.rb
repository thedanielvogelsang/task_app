# frozen_string_literal: true

class State
  attr_reader :uri, :text, :diagnostics

  def initialize(uri:, text:, diagnostics: [])
    @uri = uri
    @text = text
    @diagnostics = diagnostics
  end

  def code_actions(line_range)
    diagnostics.code_actions(line_range)
  end
end
