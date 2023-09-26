require 'spec_helper'

RSpec.describe Item do
  before(:each) do
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
  end

  describe '#initialize' do
    it 'exists' do
      expect(@item1.name).to eq("Chalkware Piggy Bank")
      expect(@item1.class).to be Item
    end
  end

  describe '#close_bidding' do
    before(:each) do
      @item1 = Item.new('Chalkware Piggy Bank')
      @item2 = Item.new('Bamboo Picture Frame')
      @item3 = Item.new('Homemade Chocolate Chip Cookies')
      @item4 = Item.new('2 Days Dogsitting')
      @item5 = Item.new('Forever Stamps')
      @auction = Auction.new
      @attendee1 = Attendee.new({name: 'Megan', budget: '$50'})
      @attendee2 = Attendee.new({name: 'Bob', budget: '$75'})
      @attendee3 = Attendee.new({name: 'Mike', budget: '$100'})
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      @item4.add_bid(@attendee3, 50)
      @item3.add_bid(@attendee2, 15)
    end

    it 'will close the item and no longer accept bids' do
      expect(@item1.closed).to eq(false)
      @item1.close!
      expect(@item1.closed).to eq(true)
      expect(@item1.bids.count).to eq(2)
      @item1.add_bid(@attendee3, 100)
      expect(@item1.bids.count).to eq(2)
      expect(@item1.current_high_bid).to eq(22)
    end
  end

end