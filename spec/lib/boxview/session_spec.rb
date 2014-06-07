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