class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def items
    @contents.keys.map do |item_id|
      Item.includes(:user).find(item_id)
    end
  end

  def subtotal_after_discounts(item_id)
    item = Item.find(item_id)
    subtotal_without_discount(item_id) - find_discount_amount(item)
  end

  def find_discount_amount(item)
    binding.pry
  end

  def total_item_count
    @contents.values.sum
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def add_item(item_id)
    @contents[item_id.to_s] ||= 0
    @contents[item_id.to_s] += 1
  end

  def subtract_item(item_id, count=1)
    @contents[item_id.to_s] -= count
    @contents.delete(item_id.to_s) if @contents[item_id.to_s] == 0
  end

  def remove_all_of_item(item_id)
    subtract_item(item_id, count_of(item_id))
  end

  def subtotal_before_discounts(item_id)
    item = Item.find(item_id)
    item.price * count_of(item_id)
  end

  def grand_total
    @contents.keys.map do |item_id|
      subtotal_before_discounts(item_id)
    end.sum
  end


end
