require 'item'
# Class for the entire tavern - responsible for holding items/ updating quality
class GildedRose
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      unless item.name == 'Sulfuras, Hand of Ragnaros'
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
    else
      update_item_quality(item)
    end
  end

  def update_bsp_quality(item)
    if item.sell_in < 0
      item.quality = MIN_QUALITY
    else
      bsp_quality_reflects_demand(item)
    end
  end

  def update_brie_quality(item)
    item.quality += 1 if item.quality < MAX_QUALITY
    item.quality += 1 if item.sell_in < MIN_QUALITY
  end

  def update_item_quality(item)
    item.quality -= 1 if item.quality > MIN_QUALITY
    item.quality -= 1 if item.quality > MIN_QUALITY && item.sell_in < 0
  end

  def update_sell_in(item)
    item.sell_in -= 1
  end

  def bsp_quality_reflects_demand(item)
    item.quality += 1 if item.quality < MAX_QUALITY
    item.quality += 1 if item.quality < MAX_QUALITY && item.sell_in < 11
    item.quality += 1 if item.quality < MAX_QUALITY && item.sell_in < 6
  end
end
