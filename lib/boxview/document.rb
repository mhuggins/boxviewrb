module BoxView
  class Document

    # ToDo: Investigate https://github.com/jwagener/httmultiparty
    # For multi part upload support

    PATH = '/documents'
    ZIP = 'zip' # Constant for generating a zip of assets of a document
    PDF = 'pdf' # Constant for generating a pdf of a document

    class << self

      attr_accessor :url, :name, :non_svg, :type, :width, :height, :retry_after#, :filepath

      # Description:
      # => The getter method for the url of a box view compatible file. Look at supported_mimetypes.
      # No Params!
      # Note:
      # => Raises an error if the url is nil.
      def url
        raise BoxView::Errors::UrlNotFound if @url.nil?
        @url
      end

      # Description:
      # => The setter method for the type of asset to be downloaded.
      # Required Params:
      # => type
      # Note:
      # => This method only accepts pdf or zip as types.
      def type=(type)
        raise BoxView::Errors::TypeNotFound if ![ZIP, PDF].include? type.downcase
        @type = type
      end

      #########################################################

      ### BEGIN Document HTTP Requests ###

      # Description:
      # => Sends a document url (and other metadata) for Box to download
      # Required Paramaters:
      # => URL: Url of the file to convert. (.pdf, .doc, .docx, .ppt, and .pptx)
      # Optional Paramaters:
      # => name: Name of the document.
      # => non_svg: false by default, enable to support < IE9 browsers
      # => width: width of a thumbnail that will be generated from this document (16-1024)
      # => height: height of a thumbnail that will be generated from this document (16-768)
      # Note:
      # => The params may be passed in when calling the function or defined before hand.
      def create(options = {})
        url options[:url] if options[:url]
        name options[:name] if options[:name]
        non_svg options[:non_svg] if options[:non_svg]
        width options[:width] if options[:width]
        height options[:height] if options[:height]
        response = BoxView.post document_path, body: json_data, headers: BoxView.headers
        create_response_handler response
        return response
      end

      # Description:
      # =>
      # No Params!
      def update(options = {})
        name options[:name] if options[:name]
        BoxView.document_id = options[:document_id] if options[:document_id]
        response = BoxView.put document_path, body: {name: name}.to_json, headers: BoxView.headers
        update_response_handler response
        return response
      end


      # Description:
      # =>
      # No Params!
      # TODO: Implement
      # def multipart
      #   BoxView.base_uri 'https://upload.view-api.box.com'
      #   response = BoxView.post multipart_path, body: multipart_json_data, headers: @multipart_headers
      #   response_handler response
      #   return response
      # end

      # Description:
      # =>
      # No Params!
      def list
        response = BoxView.get document_path, headers: BoxView.headers
        list_response_handler response
        return response
      end

      # Description:
      # =>
      # No Params!
      def show(options = {})
        BoxView.document_id = options[:document_id] if options[:document_id]
        response = BoxView.get "#{document_path}/#{BoxView.document_id}", headers: BoxView.headers
        show_response_handler response
        return response
      end

      # Description:
      # =>
      # No Params!
      def delete
        response = BoxView.delete "#{document_path}/#{BoxView.document_id}", headers: BoxView.headers
        delete_response_handler response
        return response
      end

      # Description:
      # =>
      # No Params!
      # Description:
      # =>
      # No Params!
      def assets(options = {})
        BoxView.document_id = options[:document_id] if options[:document_id]
        type options[:type] if options[:type]
        response = BoxView.get asset_url, headers: BoxView.headers
        asset_response_handler response
        return response
      end

      # Description:
      # =>
      # No Params!
      def thumbnail(options = {})
        BoxView.document_id = options[:document_id] if options[:document_id]
        width options[:width] if options[:width]
        height options[:height] if options[:height]
        response = BoxView.get thumbnail_url, headers: BoxView.headers
        thumbnail_response_handler response
        return response
      end

      ### END Document HTTP Requests ###

      # Description:
      # =>
      # No Params!
      # def multipart_headers
      #   raise BoxView::Errors::ApiKeyNotFound if BoxView.api_key.nil?
      #   {
      #     'Authorization' => "Token #{BoxView.api_key}",
      #     'Content-type' => 'multipart/form-data'
      #   }
      # end

      # Description:
      # =>
      # No Params!
      def document_path
        "#{BoxView.base_url}#{PATH}"
      end

      # Description:
      # =>
      # No Params!
      # def multipart_path
      #   "#{@multipart_path}#{BoxView::BASE_PATH}#{PATH}"
      # end

      # Description:
      # => A convenience method that contains all of the supported mimetypes of Box View.
      # No Params!
      def supported_mimetypes
        [ "application/vnd.openxmlformats-officedocument.presentationml.presentation",
          "application/vnd.openxmlformats-officedocument.presentationml.slideshow",
          "application/vnd.ms-powerpoint",
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "application/msword",
          "application/pdf"
        ]
      end

      # Description:
      # => A convenience method that contains all the supported extension types of Box View
      # No Params!
      def supported_file_extensions
        ['.pdf', '.doc', '.docx', '.ppt', '.pptx']
      end

      # Description:
      # => The asset url that is used in the request for document assets.
      # No Params!
      # Note:
      # => Type defaults to zip if not defined.
      # => A Document ID must be defined.
      def asset_url
        type = if @type then @type else ZIP end # Defaults to ZIP
        "#{BoxView.base_url}#{PATH}/#{BoxView.document_id}/content.#{type}"
      end

      # Description: Params for retrieving a thumbnail of a certain size
      # => Minimum Width and Height is 16
      # => Maximum Width is 1024
      # => Maximum Height is 768
      # No Params!
      # Note: Height and Width MUST be defined.
      def thumbnail_params
        raise BoxView::Errors::DimensionsNotFound if width.nil? || height.nil?
        "?width=#{width}&height=#{height}"
      end

      # Description:
      # =>
      # No Params!
      def dimensions
        raise BoxView::Errors::DimensionsNotFound if width.nil? || height.nil?
        "#{width}x#{height}"
      end

      # Description:
      # =>
      # No Params!
      def thumbnail_path
        "#{PATH}/#{BoxView.document_id}/thumbnail#{thumbnail_params}"
      end

      private

      # Description:
      # =>
      # No Params!
      def thumbnail_response_handler(response)
        case response.code
        when 200 # Valid thumbnail
        when 202 # Thumbnail isn't ready yet
          retry_after response['Retry-After']
        when 400 # Width/Height are invalid
          raise BoxView::Errors::ThumbnailInvalidWidthHeight
        else
          raise BoxView::Errors::ThumbnailGenerationFailed
        end
      end

      # Description:
      # =>
      # No Params!
      def thumbnail_url
        "/1/documents/#{BoxView.document_id}/thumbnail#{thumbnail_params}"
      end

      # Description:
      # =>
      # Required Params:
      # =>
      def delete_response_handler(response)
        case response.code
        when 200
        else
          # raise
        end
      end

      # Description:
      # =>
      # Required Params:
      # =>
      def asset_response_handler(response)
        case response.code
        when 200
        else
          raise BoxView::Errors::AssetGeneratioFailed.new(response)
        end
      end

      # Description:
      # =>
      # Required Params:
      # =>
      def show_response_handler(response)
        case response.code
        when 200
        else
          raise BoxView::Errors::DocumentFetchFailed.new(response)
        end
      end

      # Description:
      # =>
      # Required Params:
      # =>
      def list_response_handler(response)
        case response.code
        when 200
        else
          raise BoxView::Errors::DocumentListFetchFailed.new(response)
        end
      end

      # Description:
      # =>
      # Required Params:
      # =>
      def create_response_handler(response)
        if (200..202).include? response.code
          parsed = JSON.parse response.body
          document_id = parsed["id"]
          BoxView.document_id = document_id
        else
          raise BoxView::Errors::DocumentIdNotGenerated.new(response)
        end
      end

      # Description:
      # =>
      # Required Params:
      # =>
      def update_response_handler(response)
        if (200..202).include? response.code
          parsed = JSON.parse response.body
          document_id = parsed["id"]
          BoxView.document_id = document_id
        else
          raise BoxView::Errors::DocumentNotUpdated.new(response)
        end
      end

      # Description:
      # =>
      # No Params!
      def json_data
        data = {}
        data[:url] = url
        data[:thumbnails] = dimensions if width && height
        data[:name] = name if name
        data[:non_svg] = non_svg if non_svg
        return data.to_json
      end

      # def multipart_json_data
      #   data = {}
      #   data[:thumbnails] = dimensions if width && height
      #   data[:name] = name if name
      #   data[:non_svg] = non_svg if non_svg
      #   data[:file] = File.new(filepath, 'r') if filepath
      #   return data.to_json
      # end

    end
  end
end