# frozen_string_literal: true

require "rubocop"
require "language_server-protocol"

require "rubocop/lsp"
require "rubocop/lsp/handler"

module Rubocop
  module Lsp
    module Cli
      def self.start(_argv)
        handler = Handler.new

        handler.config do
          on("initialize") do
            store.clear

            respond_with_capabilities
          end

          on("shutdown") do
            store.clear

            nil
          end

          on("textDocument/didChange") do |request|
            uri = request.dig(:params, :textDocument, :uri)
            text = request.dig(:params, :contentChanges, 0, :text)

            collector = collect_diagnostics(uri: uri, text: text)
            send_diagnostics(collector)

            nil
          end

          on("textDocument/didOpen") do |request|
            uri = request.dig(:params, :textDocument, :uri)
            text = request.dig(:params, :textDocument, :text)

            collector = collect_diagnostics(uri: uri, text: text)
            send_diagnostics(collector)

            nil
          end

          on("textDocument/didClose") do |request|
            uri = request.dig(:params, :textDocument, :uri)

            clear_diagnostics(uri: uri)

            nil
          end

          on("textDocument/formatting") do |request|
            uri = request.dig(:params, :textDocument, :uri)

            collector = collect_diagnostics(uri: uri, text: store.text_for(uri))
            send_text_edits(collector)
          end

          on("textDocument/codeAction") do |request|
            uri = request.dig(:params, :textDocument, :uri)
            range = request.dig(:params, :range)
            start_line = range.dig(:start, :line)
            end_line = range.dig(:end, :line)

            line_range = Range.new(start_line, end_line)

            send_code_actions(uri, line_range)
          end
        end

        handler.start
      end
    end
  end
end
