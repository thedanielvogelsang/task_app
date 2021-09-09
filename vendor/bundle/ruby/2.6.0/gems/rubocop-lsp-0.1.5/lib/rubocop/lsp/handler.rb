# frozen_string_literal: true

require "rubocop/lsp/state_store"
require "rubocop/lsp/diagnostic_collector"

class Handler
  Interface = LanguageServer::Protocol::Interface
  Constant = LanguageServer::Protocol::Constant

  def initialize
    @writer = LanguageServer::Protocol::Transport::Stdio::Writer.new
    @reader = LanguageServer::Protocol::Transport::Stdio::Reader.new
    @handlers = {}
    @store = StateStore.new
  end

  def config(&blk)
    instance_exec(&blk)
  end

  def start
    reader.read do |request|
      handle(request)
    end
  end

  private

  attr_reader :writer, :reader, :store

  def on(message, &blk)
    @handlers[message.to_s] = blk
  end

  def handler_for(request)
    @handlers[request[:method]]
  end

  def handle(request)
    log("Got request method: #{request[:method]}")
    handler = handler_for(request)
    result = handler.call(request) if handler
    writer.write(id: request[:id], result: result) if result
  end

  def log(msg)
    $stderr.puts(msg)
  end

  def notify(method:, params: {})
    log("In notify: #{writer}")
    writer.write(method: method, params: params)
  end

  def respond_with_capabilities
    Interface::InitializeResult.new(
      capabilities: Interface::ServerCapabilities.new(
        text_document_sync: Interface::TextDocumentSyncOptions.new(
          change: Constant::TextDocumentSyncKind::FULL,
          open_close: true,
        ),
        document_formatting_provider: true,
        code_action_provider: true
      ),
    )
  end

  def notify_diagnostics(uri:, diagnostics_response:)
    notify(
      method: "textDocument/publishDiagnostics",
      params: Interface::PublishDiagnosticsParams.new(
        uri: uri,
        diagnostics: diagnostics_response
      )
    )
  end

  def clear_diagnostics(uri:)
    store.delete(uri)

    notify_diagnostics(uri: uri, diagnostics_response: [])
  end

  def send_diagnostics(collector)
    notify_diagnostics(
      uri: collector.uri,
      diagnostics_response: collector.diagnostics.response
    )
  end

  def send_code_actions(uri, line_range)
    store.code_actions_for(uri, line_range)
  end

  def send_text_edits(collector)
    return unless collector.formatted_text

    [
      Interface::TextEdit.new(
        range: Interface::Range.new(
          start: Interface::Position.new(line: 0, character: 0),
          end: Interface::Position.new(
            line: collector.text.size,
            character: collector.text.size
          )
        ),
        new_text: collector.formatted_text
      ),
    ]
  end

  def collect_diagnostics(uri:, text:)
    collector = DiagnosticCollector.new(uri: uri, text: text)
    collector.run

    store.set(uri: collector.uri, text: collector.text, diagnostics: collector.diagnostics)

    collector
  end
end
