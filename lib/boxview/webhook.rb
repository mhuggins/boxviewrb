# frozen_string_literal: true

require_relative "errors"

module BoxView
  module Webhook
    PATH = "/settings/webhook"

    class << self
      def create(options = {})
        response = BoxView.post(webhook_path, body: json_data(options), headers: BoxView.headers)
        fail BoxView::Errors::WebhookCreationFailed.new(response) if response.code != 200
        response
      end

      def get
        response = BoxView.get(webhook_path, headers: BoxView.headers)
        fail BoxView::Errors::WebhookFetchFailed.new(response) if response.code != 200
        response
      end

      def delete
        response = BoxView.delete(webhook_path, headers: BoxView.headers)
        fail BoxView::Errors::WebhookDeletionFailed.new(response) if response.code != 200
        response
      end

      private

      def webhook_path
        "#{BoxView::BASE_PATH}#{PATH}"
      end

      def json_data(options = {})
        data = {}
        data[:url] = options[:url]
        data.to_json
      end
    end
  end
end
