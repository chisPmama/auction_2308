class Attendee
  attr_reader :name
  attr_accessor :budget

  def initialize(hash)
    @name = hash[:name]
    @budget = hash[:budget].delete('$').to_i
  end
end