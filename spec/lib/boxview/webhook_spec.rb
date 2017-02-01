require 'spec_helper'

describe BoxView::Webhook, '#create' do
  before do
    allow(BoxView).to receive(:post).and_return(mock_response)
  end

  context 'when response is 200' do
    let(:mock_response) { double('200 Response', { :code => 200, :body => '{"url": "http://example.com"}' }) }

    it 'returns the response' do
      response = BoxView::Webhook.create(:url => 'http://example.com')
      expect(response.code).to eq(200)
    end
  end

  context 'when response is not 200' do
    let(:mock_response) { double('401 Response', { :code => 401 }) }

    it 'raises an error' do
      expect {
        BoxView::Webhook.create(:url => 'http://example.com')
      }.to raise_error(BoxView::Errors::WebhookCreationFailed)
    end
  end
end

describe BoxView::Webhook, '#delete' do
  before do
    allow(BoxView).to receive(:delete).and_return(mock_response)
  end

  context 'when response is 200' do
    let(:mock_response) { double('200 Response', { :code => 200 }) }

    it 'returns the response' do
      response = BoxView::Webhook.delete
      expect(response.code).to eq(200)
    end
  end

  context 'when response is not 200' do
    let(:mock_response) { double('401 Response', { :code => 401 }) }

    it 'raises an error' do
      expect { BoxView::Webhook.delete }.to raise_error(BoxView::Errors::WebhookDeletionFailed)
    end
  end
end

describe BoxView::Webhook, '#get' do
  before do
    allow(BoxView).to receive(:get).and_return(mock_response)
  end

  context 'when response is 200' do
    let(:mock_response) { double('200 Response', { :code => 200 }) }

    it 'returns the response' do
      response = BoxView::Webhook.get
      expect(response.code).to eq(200)
    end
  end

  context 'when response is not 200' do
    let(:mock_response) { double('401 Response', { :code => 401 }) }

    it 'raises an error' do
      expect { BoxView::Webhook.get }.to raise_error(BoxView::Errors::WebhookFetchFailed)
    end
  end
end
