require 'spec_helper'

RSpec.describe Item do
  before(:each) do
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
    @item3 = Item.new('Homemade Chocolate Chip Cookies')
    @item4 = Item.new('2 Days Dogsitting')
    @item5 = Item.new('Forever Stamps')
    @attendee = Attendee.new({name: 'Megan', budget: '$50'})
    @auction = Auction.new
  end

  describe '#initialize' do
    it 'exists' do
      expect(@attendee.name).to eq("Megan")
      expect(@attendee.budget).to eq(50)
    end
  end

  describe '#add_items' do
    it 'exists' do
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      expect(@auction.items).to eq([@item1, @item2])
    end

    it 'can return an array of strings with item names' do
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      expect(@auction.item_names).to eq(["Chalkware Piggy Bank", "Bamboo Picture Frame"])
    end
  end

  describe '#bidding' do
    before(:each) do
      @attendee1 = Attendee.new({name: 'Megan', budget: '$50'})
      @attendee2 = Attendee.new({name: 'Bob', budget: '$75'})
      @attendee3 = Attendee.new({name: 'Mike', budget: '$100'})
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
    end

    it 'checks that bids are empty initially' do
      expect(@item1.bids).to eq({})
    end

    it 'can track bids' do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      expect(@item1.bids).to eq({@attendee2=>20, @attendee1=>22})
    end

    it 'can return current highest bid on item' do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      expect(@item1.current_high_bid).to eq(22)
    end

    it 'can check most unpopular items' do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      @item4.add_bid(@attendee3, 50)
      expect(@auction.unpopular_items).to eq([@item2, @item3, @item5])
    end

    it 'can update unpopular items after a bid is made' do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      @item4.add_bid(@attendee3, 50)
      @item3.add_bid(@attendee2, 15)
      expect(@auction.unpopular_items).to eq([@item2, @item5])
    end

    it 'can return the potential revenue of the auction' do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      @item4.add_bid(@attendee3, 50)
      @item3.add_bid(@attendee2, 15)
      expect(@auction.potential_revenue).to eq(87)
    end
  end

  describe '#morebidding' do
    before(:each) do
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

    it 'can return the names of all bidders per that auction' do
      expect(@auction.bidders).to eq(["Bob", "Megan", "Mike"])
      expect(@auction.bidders.class).to be Array
    end

    it 'can return a hash with the attendee as the key and the value is a hash containing their budget and items bidded on' do
      expect(@auction.bidder_info.class).to be Hash
      expect(@auction.bidder_info.keys.first.class).to be Attendee
      expect(@auction.bidder_info.values.first.class).to be Hash
      expect(@auction.bidder_info).to eq({@attendee1 => {:budget => 50,
                                                         :items => [@item1]},
                                          @attendee2 => {:budget => 75,
                                                         :items => [@item1, @item3]},
                                          @attendee3 => {:budget => 100,
                                                         :items => [@item4]}
                                        })
    end
  end
end