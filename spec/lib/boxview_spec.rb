require 'spec_helper'

describe BoxView, "#headers" do
  it 'should raise error when api key is nil' do
    BoxView.api_key = nil
    expect{BoxView.headers}.to raise_error(BoxView::Errors::ApiKeyNotFound)
  end
  it 'should return headers when api key is defined' do
    BoxView.api_key = "a1s2d9d3dg7d7s7"
    expect(BoxView.headers).not_to be_nil
  end
  it 'should return when document id is defined' do
    BoxView.document_id = "slkslkdf234234"
    expect(BoxView.document_id).not_to be_nil
  end
  it 'should raise error when document id is nil' do
    BoxView.document_id = nil
    expect{BoxView.document_id}.to raise_error(BoxView::Errors::DocumentIdNotFound)
  end
  it 'should return when session id is defined' do
    BoxView.session_id = "sfsdf23242332"
    expect(BoxView.session_id).not_to be_nil
  end
  it 'should raise error when session id is nil' do
    BoxView.session_id = nil
    expect{BoxView.session_id}.to raise_error(BoxView::Errors::SessionIdNotFound)
  end
end