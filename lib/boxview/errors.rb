module BoxView
  class Errors < StandardError

    @error = nil

    def error
      @error
    end

    def initialize(message, error = nil)
      # super message
      @error = error
      if error.nil?
        super message
      else
        case error
          when 400 then super "#{message} - Error Code: 400 - Document does not exist or failed converting."
          else super message
        end
      end
    end

    class DocumentNotUpdated < StandardError
      DOCUMENT_UPDATE_ERROR_MESSAGE = "The document failed to update."
      def initialize(response = nil)
        super "#{DOCUMENT_UPDATE_ERROR_MESSAGE} - with ID: #{BoxView.document_id} - Response Code: #{response.code}"
      end
    end

    class AssetGenerationFailed < StandardError
      ASSET_GENERATION_ERROR_MESSAGE = "The assets failed to generate."
      def initialize(response = nil)
        super "#{ASSET_GENERATION_ERROR_MESSAGE} - with ID: #{BoxView.document_id} - Response Code: #{response.code}"
      end
    end

    class DocumentListFetchFailed < StandardError
      DOCUMENT_LIST_ERROR_MESSAGE = "Could not fetch document list."
      def initialize(response = nil)
        super "#{DOCUMENT_LIST_ERROR_MESSAGE} - Response Code: #{response.code}"
      end
    end

    class DocumentFetchFailed < StandardError
      DOCUMENT_ERROR_MESSAGE = "Could not fetch document."
      def initialize(response = nil)
        super "#{DOCUMENT_ERROR_MESSAGE} - with ID: #{BoxView.document_id} - Response Code: #{response.code}"
      end
    end

    class DocumentIdNotGenerated < StandardError
      DOCUMENT_ID_ERROR_MESSAGE = "The document id has failed to be generated."
      def initialize(response = nil)
        if response
          super "#{DOCUMENT_ID_ERROR_MESSAGE} - Response Code: #{response.code}"
        else
          super DOCUMENT_ID_ERROR_MESSAGE
        end
      end
    end

    class DocumentConversionFailed < StandardError
      CONVERSION_ERROR_MESSAGE = "Converting the document has failed."
      def initialize
        super CONVERSION_ERROR_MESSAGE
      end
    end

    class SessionNotGenerated < StandardError
      GENERATION_ERROR_MESSAGE = "Session could not be generated."
      def initialize
        super GENERATION_ERROR_MESSAGE
      end
    end

    class ThumbnailGenerationFailed < StandardError
      GENERATION_ERROR_MESSAGE = "Thumbnail could not be generated."
      def initialize
        super GENERATION_ERROR_MESSAGE
      end
    end

    class ThumbnailInvalidWidthHeight < StandardError
      WIDTH_HEIGHT_ERROR_MESSAGE = "The thumbnails width or height is invalid."
      def initialize
        super WIDTH_HEIGHT_ERROR_MESSAGE
      end
    end

    class ApiKeyNotFound < StandardError
      API_KEY_ERROR_MESSAGE = "API Key is nil." # test to make sure it is string, digits and alphanumeric, correct length?
      def initialize
        super API_KEY_ERROR_MESSAGE
      end
    end

    class DimensionsNotFound < StandardError
      DIMENSIONS_ERROR_MESSAGE = "Height and Width must both be specified."
      def initialize
        super DIMENSIONS_ERROR_MESSAGE
      end
    end

    class DocumentIdNotFound < StandardError
      DOCUMENT_ID_ERROR_MESSAGE = "Document ID must be specified."
      def initialize
        super DOCUMENT_ID_ERROR_MESSAGE
      end
    end

    class ExpirationDateNotFound < StandardError
      EXPIRATION_DATE_ERROR_MESSAGE = "An Expiration Date must be specified."
      def initialize
        super EXPIRATION_DATE_ERROR_MESSAGE
      end
    end

    class SessionIdNotFound < StandardError
      SESSION_ID_ERROR_MESSAGE = "A Session ID must be specified."
      def initialize
        super SESSION_ID_ERROR_MESSAGE
      end
    end

    class TypeNotFound < StandardError
      TYPE_ERROR_MESSAGE = "A type must be specified."
      def initialize
        super TYPE_ERROR_MESSAGE
      end
    end

  end
end