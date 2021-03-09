require_relative './gilded_rose'

RSpec.describe "GildedRose" do
  let!(:items) do
    [
     Item.new("+5 Dexterity Vest", 10, 20),
     Item.new("Aged Brie", 2, 0),
     Item.new("Elixir of the Mongoose", 5, 7),
     Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
     Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
     Item.new("Conjured Mana Cake", 3, 6),
    ]
  end

  context "Normal Items" do
    let!(:items) do
      [
        Item.new("+5 Dexterity Vest", 10, 20),
        Item.new("Elixir of the Mongoose", 5, 7)
      ]
    end

    it "should decrease sell_in and quality by 1" do
      update_quality(items)

      expect(items[0].sell_in).to eq 9
      expect(items[0].quality).to eq 19

      expect(items[1].sell_in).to eq 4
      expect(items[1].quality).to eq 6
    end
  end

  context "Items Past Sell Date" do
    let!(:items) do
      [
        Item.new("+5 Dexterity Vest", 0, 20),
        Item.new("Elixir of the Mongoose", -1, 7)
      ]
    end

    it "should decrease sell_in by 1 and quality (twice as fast) by 2" do
      update_quality(items)

      expect(items[0].sell_in).to eq -1
      expect(items[0].quality).to eq 18

      expect(items[1].sell_in).to eq -2
      expect(items[1].quality).to eq 5
    end
  end

  context "Aged Brie" do
    let!(:items) do
      [
        Item.new("Aged Brie", 2, 0)
      ]
    end

    it "should decrease sell_in by 1 and increase quality by 1" do
      update_quality(items)

      expect(items[0].sell_in).to eq 1
      expect(items[0].quality).to eq 1
    end
  end

  context "Legendary Items" do
    let!(:items) do
      [
        Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
      ]
    end

    it "should have constant sell_in and quality" do
      update_quality(items)

      expect(items[0].sell_in).to eq 0
      expect(items[0].quality).to eq 80
    end
  end

  context "Backstage Passes" do
    let!(:items) do
      [
        Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 7, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 2, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 20)
      ]
    end

    it "should decrease sell_in by 1 and increase quality by 1" do
      update_quality(items)

      expect(items[0].sell_in).to eq 14
      expect(items[0].quality).to eq 21
    end

    it "should decrease sell_in by 1 and increase quality by 2 when sell_in is less than or equal to 10" do
      update_quality(items)

      expect(items[1].sell_in).to eq 6
      expect(items[1].quality).to eq 22
    end

    it "should decrease sell_in by 1 and increase quality by 3 when sell_in is less than or equal to 5" do
      update_quality(items)

      expect(items[2].sell_in).to eq 1
      expect(items[2].quality).to eq 23
    end

    it "should decrease sell_in by 1 and drop quality to 0 when sell_in is less than or equal to 0 (zero or negative)" do
      update_quality(items)

      expect(items[3].sell_in).to eq -2
      expect(items[3].quality).to eq 0
    end
  end

  context "Conjured Items" do
    let!(:items) do
      [
        Item.new("Conjured Mana Cake", 3, 6)
      ]
    end

    it "should decrease sell_in by 1 and quality by 2" do
      update_quality(items)

      expect(items[0].sell_in).to eq 2
      expect(items[0].quality).to eq 4
    end
  end

  context "(Lower Limit) Item Quality" do
    let!(:items) do
      [
        Item.new("+5 Dexterity Vest", 0, 0),
        Item.new("Elixir of the Mongoose", -1, 1)
      ]
    end

    it "should never be less than 0 (negative)" do
      update_quality(items)

      expect(items[0].sell_in).to eq -1
      expect(items[0].quality).to eq 0

      expect(items[1].sell_in).to eq -2
      expect(items[1].quality).to eq 0
    end
  end

  context "(Higher Limit) Item Quality" do
    let!(:items) do
      [
        Item.new("Aged Brie", 2, 50)
      ]
    end

    it "should never be more than 50" do
      update_quality(items)

      expect(items[0].sell_in).to eq 1
      expect(items[0].quality).to eq 50
    end
  end


end
