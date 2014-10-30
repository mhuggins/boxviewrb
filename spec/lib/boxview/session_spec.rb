require 'spec_helper'

describe BoxView::Session, '#expiration_date' do
  it 'should raise error when expiration date is nil' do
    BoxView::Session.expiration_date = nil
    expect{BoxView::Session.expiration_date}.to raise_error(BoxView::Errors::ExpirationDateNotFound)
  end

  it 'should return when expiration date is defined' do
    BoxView::Session.expiration_date = Time.now
    expect(BoxView::Session.expiration_date).not_to be_nil
  end
end

describe BoxView::Session, '#duration' do
  it 'should raise error when duration is nil' do
    BoxView::Session.duration = nil
    expect{BoxView::Session.duration}.to raise_error(BoxView::Errors::DurationNotFound)
  end

  it 'should return when duration is defined' do
    BoxView::Session.duration = 100
    expect(BoxView::Session.duration).not_to be_nil
  end
end

describe BoxView::Session, '#create' do
  before do
    allow(BoxView).to receive(:post).and_return(mock_response)
  end

  context 'when response is 202' do
    let(:mock_response) { double('202 Response', { :code => 202, :headers => { 'retry-after' => '2' }, }) }

    it 'should set retry_after' do
      BoxView::Session.create({ :document_id => '123'})
      expect(BoxView::Session.retry_after).to eql('2')
    end
  end
end