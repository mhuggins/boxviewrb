module BoxView
  class Session

    @path = '/sessions'

    @@expiration_date = nil

    @@duration = nil

    class << self

      ### BEGIN Getters AND Setters ###

      # Description:
      # =>
      # Required Params:
      # =>
      def duration=(duration)
        @@duration = duration
      end

      # Description:
      # =>
      # No Params!
      def duration
        raise BoxView::Errors::DurationNotFound if @@duration.nil?
        @@duration
      end

      # Description:
      # =>
      # Required Params:
      # =>
      def expiration_date=(expiration_date)
        @@expiration_date = expiration_date
      end

      # Description:
      # =>
      # No Params!
      def expiration_date
        raise BoxView::Errors::ExpirationDateNotFound if @@expiration_date.nil?
        @@expiration_date
      end

      # Description:
      # => The setter method for the retry after time while the session is being generated.
      # Required Params:
      # => retry_after
      def retry_after=(retry_after)
        @@retry_after = retry_after
      end

      # Description:
      # => The getter method for the retry after time while the session is being generated.
      # No Params!
      def retry_after
        @@retry_after
      end

      ### END Getters AND Setters ###

      ### BEGIN Session HTTP Request ###

      # Description:
      # => Method that creates a session, uses HTTParty for network calls
      # Required Params:
      # =>
      # Note:
      # => params can be defined elsewhere.
      # => document id must be defined.
      def create(options = {})
        BoxView.document_id options[:document_id] if options[:document_id]
        duration options[:duration] if options[:duration]
        expiration_date options[:expiration_date] if options[:expiration_date]
        response = BoxView.post session_path, body: json_data, headers: BoxView.headers
        response_handler response
        return response
      end

      ### END Session HTTP Request ###

      # Description:
      # =>
      # No Params!
      def session_path
        "#{BoxView::base_url}#{BoxView::base_path}#{@path}"
      end

      # Description:
      # => Convenience method to make the session last for a thousand years
      # No Params!
      def never_expire
        expiration_date Time.now + (365.25 * 24 * 60 * 60 * 1000).to_i
      end

      # Description:
      # => A convenience method to return the viewer url that can be used after generating a session.
      # Note:
      # => No Required Params!
      # => Defaults to using a generated session_id.
      def viewer_url(session_id = nil)
        unless session_id then session_id = BoxView.session_id end
        "#{session_path}/#{session_id}/view?theme=light"
      end

      # Description:
      # => A convenience method to return the asset url that is used in viewerjs.
      # Optional Params:
      # => session_id
      # Note:
      # => No Required Params!
      # => Defaults to using a generated session_id.
      def viewerjs_url(session_id = nil)
        unless session_id then session_id = BoxView.session_id end
        "#{session_path}/#{session_id}/assets"
      end

      # Description:
      # => Convenience method to open the viewer url in a default browser.
      # Optional Params:
      # => A url to open in a default browser.
      # Note:
      # => No Required Params!
      # => A session must have been generated in order for a url to be generated.
      def view(link = nil)
        unless link then link = viewer_url end
        if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
          system "start #{link}"
        elsif RbConfig::CONFIG['host_os'] =~ /darwin/
          system "open #{link}"
        elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
          system "xdg-open #{link}"
        end
      end

      private

      # Description:
      # =>
      # No Params!
      def response_handler(response)
        case response.code
        when 201 # Done converting
          parsed = JSON.parse response.body
          session_id = parsed["id"]
          BoxView.session_id session_id
        when 202 # Session not ready yet
          retry_after response['Retry-After']
        when 400 # An error occurred while converting the document or the document does not exist
          raise BoxView::Errors::DocumentConversionFailed
        else
          raise BoxView::Errors::SessionNotGenerated
        end
      end

      # Description:
      # =>
      # No Params!
      def json_data # Does a duration or an expiration date need to exist?
        data = {}
        data["document_id"] = BoxView.document_id
        if !@@duration.nil? && @@expiration_date.nil? # duration
          data["duration"] = @@duration
        elsif @@duration.nil? && !@@expiration_date.nil? # expiration
          data["expiration_date"] = @@expiration_date
        elsif !@@duration.nil? && !@@expiration_date.nil? # both, use expiration date
          data["expiration_date"] = @@expiration_date
        else
          # Default will be used
        end
        return data.to_json
      end
    end
  end
end