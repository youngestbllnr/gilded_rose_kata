def update_quality(items)
  items.each do |item|
    item_type = get_item_type(item)
    quality_limit_reached = past_quality_limits?(item, item_type)

    unless item_type == "Legendary Item"
      unless quality_limit_reached
        item.quality += get_quality_increment(item, item_type)
        item.quality = 0 if item.quality < 0
      end
      item.sell_in -= 1
    end
  end
end

#RETURNS ITEM TYPE
def get_item_type(item)
  case
    when item.name.include?("Aged Brie")
      "Aged Brie"
    when item.name.include?("Sulfuras")
      "Legendary Item"
    when item.name.include?("Backstage")
      "Backstage Pass"
    when item.name.include?("Conjured")
      "Conjured Item"
    when item.sell_in <= 0
      "Item Past Sell Date"
    else
      "Normal Item"
  end
end

#DETERMINES IF ITEM HAS REACHED ITS QUALITY LIMIT
def past_quality_limits?(item, type)
  if type == "Aged Brie" || type == "Backstage Pass"
    item.quality > 49
  else
    item.quality < 1
  end
end

def get_quality_increment(item, item_type)
  case item_type
    when "Aged Brie"
      1
    when "Conjured Item"
      -2
    when "Backstage Pass"
      get_pass_increment(item)
    when "Item Past Sell Date"
      -2
    else
      -1
    end
end

def get_pass_increment(pass)
  case
    when pass.sell_in.between?(0, 6)
      3
    when pass.sell_in.between?(5, 11)
      2
    when pass.sell_in > 10
      1
    else
      -pass.quality
    end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

