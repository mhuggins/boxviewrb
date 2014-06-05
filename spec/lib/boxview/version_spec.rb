require 'spec_helper'

describe BoxView::VERSION do
  it 'should not be nil' do
    expect(BoxView::VERSION).to_not be_nil
  end

  it 'should be a string' do
    expect(BoxView::VERSION).to be_an_instance_of(String)
  end
end