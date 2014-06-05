require 'httparty'

require_relative 'boxview/document'
require_relative 'boxview/session'
require_relative 'boxview/errors'

module BoxView
  include HTTParty

  base_uri 'https://view-api.box.com'

  @@api_key = nil # API KEY from a BoxView Application

  @@base_url = base_uri

  @@base_path = '/1'

  @@document_id = nil

  @@session_id = nil

  class << self

    # Description:
    # =>
    # No Params!
    def headers
      raise BoxView::Errors::ApiKeyNotFound if @@api_key.nil?
      {
        'Authorization' => "Token #{@@api_key}",
        'Content-type' => 'application/json'
      }
    end

    # Description:
    # =>
    # Required:
    # =>
    def api_key=(api_key)
      @@api_key = api_key
    end

    # Description:
    # =>
    # No Params!
    def api_key
      @@api_key
    end

    # Description:
    # =>
    # No Params!
    def base_url
      @@base_url
    end

    # Description:
    # =>
    # No Params!
    def base_path
      @@base_path
    end

    # Description:
    # =>
    # Required:
    # =>
    def document_id=(document_id)
      @@document_id = document_id
    end

    # Description:
    # =>
    # No Params!
    def document_id
      raise BoxView::Errors::DocumentIdNotFound if @@document_id.nil?
      @@document_id
    end

    # Description:
    # =>
    # Required:
    # =>
    def session_id=(session_id)
      @@session_id = session_id
    end

    # Description:
    # =>
    # No Params!
    def session_id
      raise BoxView::Errors::SessionIdNotFound if @@session_id.nil?
      @@session_id
    end
  end
end