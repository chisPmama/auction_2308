require 'spec_helper'

RSpec.describe Auction do
  before(:each) do
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
    @attendee = Attendee.new({name: 'Megan', budget: '$50'})
    @auction = Auction.new
  end

  describe '#initialize' do
    it 'exists' do
      expect(@auction.class).to be Auction
      expect(@auction.items).to eq([])
    end
  end
end