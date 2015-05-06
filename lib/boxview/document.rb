module BoxView
  class Document

    # ToDo: Investigate https://github.com/jwagener/httmultiparty
    # For multi part upload support

    PATH = '/documents'
    ZIP = 'zip' # Constant for generating a zip of assets of a document
    PDF = 'pdf' # Constant for generating a pdf of a document
    ORIGINAL_FORMAT = '' # Constant for fetching the original uploaded file

    class << self

      attr_accessor :url, :name, :non_svg, :type, :width, :height, :retry_after, :filepath

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
      # => The getter method for the filepath of a box view compatible file. Look at supported_mimetypes.
      # No Params!
      # Note:
      # => Raises an error if the filepath is nil or does not exist.
      def filepath
        raise BoxView::Errors::FilepathNotFound if @filepath.nil? || !File.file?(@filepath)
        @filepath
      end

      # Description:
      # => The setter method for the type of asset to be downloaded.
      # Required Params:
      # => type
      # Note:
      # => This method only accepts pdf or zip as types.
      def type=(type)
        raise BoxView::Errors::TypeNotFound if ![ZIP, PDF, ORIGINAL_FORMAT].include? type.downcase
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
        response = BoxView.post document_path, body: json_data(options), headers: BoxView.headers
        create_response_handler response
        return response
      end

      # Description:
      # => Allows metadata, specifically the name of a document to be updated. Requires a document id.
      # Optional Params:
      # => Name, Document ID
      def update(options = {})
        @name = options[:name] if options[:name]
        BoxView.document_id = options[:document_id] if options[:document_id]
        response = BoxView.put document_path, body: {name: name}.to_json, headers: BoxView.headers
        update_response_handler response
        return response
      end


      # Description:
      # => Uses https://github.com/jwagener/httmultiparty for multipart uploading while still using HTTParty
      # No Params!
      def multipart(options = {})
        BoxView.base_uri BoxView::MULTIPART_URI
        (multipart_headers = BoxView.headers).delete('Content-type')
        response = BoxView.post document_path, body: multipart_data(options), headers: multipart_headers, detect_mime_type: true
        multipart_response_handler response
        return response
      end

      # Description:
      # => This request will list all the current documents that were uploaded to box view by api key.
      # No Params!
      def list
        response = BoxView.get document_path, headers: BoxView.headers
        list_response_handler response
        return response
      end

      # Description:
      # => Returns the box view object for a specific document. Requires a document id.
      # No Params!
      def show(options = {})
        BoxView.document_id = options[:document_id] if options[:document_id]
        response = BoxView.get "#{document_path}/#{BoxView.document_id}", headers: BoxView.headers
        show_response_handler response
        return response
      end

      # Description:
      # => Delete a document from box view given a document id.
      # No Required Params!
      # Optional Params:
      # => Document ID
      def delete(options = {})
        BoxView.document_id = options[:document_id] if options[:document_id]
        response = BoxView.delete "#{document_path}/#{BoxView.document_id}", headers: BoxView.headers
        delete_response_handler response
        return response
      end

      # Description:
      # =>
      # No Params!
      # Description:
      # => Returns a pdf or zip representation of a document that has previously been uploaded to box view. Requires a document id.
      # No Required Params!
      # Optional Params:
      # => Type, Document ID
      def assets(options = {})
        BoxView.document_id = options[:document_id] if options[:document_id]
        self.type = options[:type] if options[:type]
        response = BoxView.get asset_url, headers: BoxView.headers
        asset_response_handler response
        return response
      end

      # Description:
      # => Returns a thumbnail image representation of a document that has previously been uploaded to box view. Requires a document id.
      # => Inform BoxView early by specifying width and height when creating the document.
      # No Required Params!
      # Optional Params:
      # => Width, Height, Document ID
      def thumbnail(options = {})
        BoxView.document_id = options[:document_id] if options[:document_id]
        @width = options[:width] if options[:width]
        @height = options[:height] if options[:height]
        response = BoxView.get thumbnail_url, headers: BoxView.headers
        thumbnail_response_handler response
        return response
      end

      ### END Document HTTP Requests ###

      # Description:
      # => A path that is used for all document related requests.
      # No Params!
      def document_path
        "#{BoxView::BASE_PATH}#{PATH}"
      end

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
        rtn = "#{document_path}/#{BoxView.document_id}/content"
        unless type == ORIGINAL_FORMAT
          rtn += ".#{type}"
        end
        rtn
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
      # => Path to request thumbnail generation for a specific document. Requires document id, width and height.
      # No Params!
      def thumbnail_url
        "#{document_path}/#{BoxView.document_id}/thumbnail#{thumbnail_params}"
      end

      private

      # Description:
      # => Response Handler for the thumbnail request
      # Required Params:
      # => response
      def thumbnail_response_handler(response)
        case response.code
        when 200 # Valid thumbnail
        when 202 # Thumbnail isn't ready yet
          retry_after = response['Retry-After']
        when 400 # Width/Height are invalid
          raise BoxView::Errors::ThumbnailInvalidWidthHeight
        else
          raise BoxView::Errors::ThumbnailGenerationFailed
        end
      end

      # Description:
      # => Response Handler for the delete request
      # Required Params:
      # => response
      def delete_response_handler(response)
        case response.code
        when 200
        when 204
        else
          raise BoxView::Errors::DocumentDeletionFailed.new(response)
        end
      end

      # Description:
      # => Response Handler for the asset request
      # Required Params:
      # => response
      def asset_response_handler(response)
        case response.code
        when 200
        else
          raise BoxView::Errors::AssetGenerationFailed.new(response)
        end
      end

      # Description:
      # => Response Handler for the show request
      # Required Params:
      # => response
      def show_response_handler(response)
        case response.code
        when 200
        else
          raise BoxView::Errors::DocumentFetchFailed.new(response)
        end
      end

      # Description:
      # => Response Handler for the list request
      # Required Params:
      # => response
      def list_response_handler(response)
        case response.code
        when 200
        else
          raise BoxView::Errors::DocumentListFetchFailed.new(response)
        end
      end

      # Description:
      # => Response Handler for the create request
      # Required Params:
      # => response
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
      # => Response Handler for the update request
      # Required Params:
      # => response
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
      # => Response Handler for the multipart request
      # Required Params:
      # => response
      def multipart_response_handler(response)
        BoxView.base_uri BoxView::BASE_URI # restores original base_uri
        if (200..202).include? response.code
          parsed = JSON.parse response.body
          document_id = parsed["id"]
          BoxView.document_id = document_id
        else
          raise BoxView::Errors::DocumentNotUpdated.new(response)
        end
      end

      # Description:
      # => The JSON that is sent in document creation requests.
      # No Required Params!
      # Optional Params:
      # => URL, Name, Width, Height, non_svg
      def json_data(options = {})
        options.each do |k,v|
          send "#{k}=", v if v
        end
        data = {}
        data[:url] = url
        data[:name] = name if name
        data[:thumbnails] = dimensions if width && height
        data[:non_svg] = non_svg if non_svg
        return data.to_json
      end

      # Description:
      # => The hash that is sent in document multipart requests.
      # No Required Params!
      # Optional Params:
      # => Filepath, Name, Width, Height, non_svg
      def multipart_data(options = {})
        options.each do |k,v|
          send "#{k}=", v if v
        end
        data = {}
        data[:file] = File.new(filepath, 'r') if filepath
        data[:name] = name if name
        data[:thumbnails] = dimensions if width && height
        data[:non_svg] = non_svg if non_svg
        return data
      end

    end
  end
end
