require 'item'

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_sell_in(item)
      update_item_quality(item)
      update_bsp_quality(item)
      update_brie_quality(item)
    end
  end

  private

  def special?(item)
    ['Aged Brie', 'Backstage passes to a TAFKAL80ETC concert',
     'Sulfuras, Hand of Ragnaros'].include?(item.name)
  end

  def update_item_quality(item)
    unless special?(item)
      item.quality -= 1 if item.quality > 0
      item.quality -= 1 if item.quality > 0 && item.sell_in < 0
    end
  end

  def update_bsp_quality(item)
    if item.name == 'Backstage passes to a TAFKAL80ETC concert'
      if item.sell_in >= 0
        item.quality += 1 if item.quality < 50
        item.quality += 1 if item.quality < 50 && item.sell_in < 11
        item.quality += 1 if item.quality < 50 && item.sell_in < 6
      else
        item.quality = 0
      end
    end
  end

  def update_brie_quality(item)
    if item.name == 'Aged Brie'
      item.quality += 1 if item.quality < 50
      item.quality += 1 if item.sell_in < 0
    end
  end

  def update_sell_in(item)
    item.sell_in -= 1 unless item.name == 'Sulfuras, Hand of Ragnaros'
  end
end
