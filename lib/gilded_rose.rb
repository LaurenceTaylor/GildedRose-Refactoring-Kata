require 'item'
# Class for the entire tavern - responsible for holding items/ updating quality
class GildedRose
  MAX_QUALITY = 50
  MIN_QUALITY = 0
  LEGENDARY_ITEMS = ['Sulfuras, Hand of Ragnaros'].freeze

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      unless LEGENDARY_ITEMS.include?(item.name)
        update_sell_in(item)
        update_quality_logic(item)
      end
    end
  end

  private

  def update_quality_logic(item)
    case item.name
    when 'Backstage passes to a TAFKAL80ETC concert'
      update_bsp_quality(item)
    when 'Aged Brie'
      update_brie_quality(item)
    when 'Conjured'
      update_conjured_quality(item)
    else
      update_item_quality(item)
    end
  end

  def update_bsp_quality(item)
    if item.sell_in < 0
      item.quality = MIN_QUALITY
    else
      bsp_quality_increase_reflects_demand(item)
    end
  end

  def update_brie_quality(item)
    increase_quality_by_one(item)
    increase_quality_by_one(item) if item.sell_in < 0
  end

  def update_conjured_quality(item)
    2.times { update_item_quality(item) }
  end

  def update_item_quality(item)
    decrease_quality_by_one(item)
    decrease_quality_by_one(item) if item.sell_in < 0
  end

  def update_sell_in(item)
    item.sell_in -= 1
  end

  def bsp_quality_increase_reflects_demand(item)
    increase_quality_by_one(item)
    increase_quality_by_one(item) if item.sell_in < 11
    increase_quality_by_one(item) if item.sell_in < 6
  end

  def increase_quality_by_one(item)
    item.quality += 1 if item.quality < MAX_QUALITY
  end

  def decrease_quality_by_one(item)
    item.quality -= 1 if item.quality > MIN_QUALITY
  end
end
