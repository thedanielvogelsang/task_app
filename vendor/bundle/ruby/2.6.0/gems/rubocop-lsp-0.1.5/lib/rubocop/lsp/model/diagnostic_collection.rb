# frozen_string_literal: true

require "rubocop/lsp/model/diagnostic"

module Model
  Interface = LanguageServer::Protocol::Interface
  Constant = LanguageServer::Protocol::Constant

  class DiagnosticCollection
    attr_reader :uri, :diagnostics

    def initialize(uri, offenses)
      @uri = uri
      @diagnostics = offenses.map do |offense|
        Diagnostic.new(offense)
      end
    end

    def response
      diagnostics.map(&:diagnostic_response)
    end

    def correctable_diagnostics
      @correctable_diagnostics ||= diagnostics.select(&:correctable?)
    end

    def code_actions(line_range)
      line_diagnostics = correctable_diagnostics.select do |diagnostic|
        line_range.include?(diagnostic.start.line)
      end

      actions = line_diagnostics.map do |diagnostic|
        code_action_from(
          diagnostic,
          title: "Autocorrect `#{diagnostic.cop_name}`",
          kind: Constant::CodeActionKind::QUICK_FIX
        )
      end

      if actions.any?
        actions << code_action_from(
          line_diagnostics,
          title: "Autocorrect all offenses on line",
          kind: "rubocop.fix"
        )
      end

      actions
    end

    private

    def code_action_from(diagnostics, title:, kind:)
      diagnostics = Array(diagnostics)

      Interface::CodeAction.new(
        title: title,
        kind: kind,
        edit: Interface::WorkspaceEdit.new(
          document_changes: [
            Interface::TextDocumentEdit.new(
              text_document: Interface::OptionalVersionedTextDocumentIdentifier.new(
                uri: uri,
                version: nil
              ),
              edits: diagnostics.flat_map(&:replacements)
            ),
          ]
        ),
        is_preferred: true,
      )
    end
  end
end
