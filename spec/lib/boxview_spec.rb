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
end