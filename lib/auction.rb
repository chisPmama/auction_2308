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

  # def date
  #   @date = Date.today.strftime("%d/%m/%Y")
  # end
end