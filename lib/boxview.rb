require 'httmultiparty'

require_relative 'boxview/document'
require_relative 'boxview/session'
require_relative 'boxview/errors'

module BoxView
  include HTTMultiParty

  BASE_URI = 'https://view-api.box.com'

  MULTIPART_URI = 'https://upload.view-api.box.com'

  BASE_PATH = '/1'

  base_uri BASE_URI

  class << self

    attr_accessor :api_key, :document_id, :session_id

    # Description:
    # =>
    # No Params!
    def headers
      {
        'Authorization' => "Token #{api_key}",
        'Content-type' => 'application/json'
      }
    end

    # Description:
    # =>
    # No Params!
    def api_key
      raise BoxView::Errors::ApiKeyNotFound if @api_key.nil?
      @api_key
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