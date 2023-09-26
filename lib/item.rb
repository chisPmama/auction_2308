class Item
  attr_reader :name, :bids

  def initialize(name)
    @name = name
    @bids = Hash.new(0)
  end

  def add_bid(attendee, bid)
    bids[attendee]=bid
  end

  def current_high_bid
    return 0 if bids.empty?
    bids.max_by{|k,v| v}.last
  end
end