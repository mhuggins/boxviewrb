require 'httparty'

require_relative 'boxview/document'
require_relative 'boxview/session'
require_relative 'boxview/errors'

module BoxView
  include HTTParty
  # include HTTMultiParty

  base_uri 'https://view-api.box.com'

  BASE_PATH = '/1'

  class << self

    attr_accessor :api_key, :document_id, :session_id

    # Description:
    # =>
    # No Params!
    def headers
      raise BoxView::Errors::ApiKeyNotFound if @api_key.nil?
      {
        'Authorization' => "Token #{@api_key}",
        'Content-type' => 'application/json'
      }
    end

    # Description:
    # =>
    # No Params!
    def document_id
      raise BoxView::Errors::DocumentIdNotFound if @document_id.nil?
      @document_id
    end

    # Description:
    # =>
    # No Params!
    def session_id
      raise BoxView::Errors::SessionIdNotFound if @session_id.nil?
      @session_id
    end
  end
end