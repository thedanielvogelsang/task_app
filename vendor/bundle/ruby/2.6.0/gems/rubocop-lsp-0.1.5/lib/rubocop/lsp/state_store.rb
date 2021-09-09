# frozen_string_literal: true

require "rubocop/lsp/state"

class StateStore
  def initialize
    @state_map = {}
  end

  def clear
    @state_map = {}
  end

  def delete(uri)
    @state_map.delete(uri)
    []
  end

  def set(uri:, text:, diagnostics: [])
    @state_map[uri] = State.new(uri: uri, text: text, diagnostics: diagnostics || [])
  end

  def get(uri)
    @state_map[uri]
  end

  def text_for(uri)
    state = get(uri)

    return state.text if state

    file = CGI.unescape(URI.parse(uri).path)
    File.binread(file)
  end

  def code_actions_for(uri, line_range)
    state = get(uri)

    return [] unless state

    state.code_actions(line_range)
  end

  private

  attr_reader :state_map
end
