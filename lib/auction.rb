require 'date'

class Auction
  attr_reader :items, :date
  def initialize
    @items = []
    @date = Date.today.strftime("%d/%m/%Y")
  end

  def add_item(item)
    items << item
  end

  def item_names
    items.map{|item| item.name}
  end

  def unpopular_items
    items.find_all{|item| item.bids.values.sum == 0}
  end

  def potential_revenue
    items.map{|item| item.current_high_bid}.sum
  end

  def bidders
    names = @items.map do |item|
      item.bids.map do |attendee, bids|
        attendee.name
      end
    end
    names.flatten.uniq
  end

  def bidders_objects
    objects = @items.map do |item|
      item.bids.map do |attendee, bids|
        attendee
      end
    end
    objects.flatten.uniq
  end

  def items_per_attendee(attendee_name)
    items_list = items.find_all do |item|
      item.bids.keys.find{|attendee| attendee.name == attendee_name}
    end
    items_list
  end

  def bidder_info
    info = {}
    bidders_objects.each do |attendee|
      info[attendee] = {:budget => attendee.budget, :items => items_per_attendee(attendee.name)}
    end
    info
  end

  def close_auction
    items.each{|item| item.close!}
    sell_with_logic
  end

  def sell
    sell = {}
    items.each do |item|
      if item.bids.empty?
        sell[item] = 'Not Sold'
      else
        sell[item] = item.bids.max_by{|attendee, bid| bid}.first
      end
    end
    sell
  end

  def sell_with_logic
    sell = {}
    unpopular_items.each{|item| sell[item] = 'Not Sold'}
    items_sold = items.find_all{|item| !item.bids.empty?}
    items_sold.each do |item|
      item_bidders = item.bids.sort_by{|attendee, bid| -bid}.to_h
      until sell[item]
      highest_bidder = item_bidders.first
      their_bid = item_bidders.first.last
      if (highest_bidder.first.budget-their_bid) > 0
        sell[item] = highest_bidder
        their_budget = highest_bidder.first.budget
        highest_bidder.first.budget = their_budget - their_bid
      else
        item_bidders.shift
      end
      end
    end
  end

end