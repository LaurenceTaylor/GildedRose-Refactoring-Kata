# Class for the entire tavern - responsible for holding items/ updating quality
class GildedRose
  MAX_QUALITY = 50
  MIN_QUALITY = 0
  LEGENDARY_ITEMS = ['Sulfuras, Hand of Ragnaros'].freeze
  CONJURED_MULTIPLIER = 2

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_item(item)
    end
  end

  private

  def update_item(item)
    return if legendary?(item)
    update_sell_in(item)
    update_quality_logic(item)
  end

  def update_quality_logic(item)
    if backstage_pass?(item)
      update_bsp_quality(item)
    elsif aged_brie?(item)
      update_brie_quality(item)
    elsif conjured?(item)
      update_conjured_quality(item)
    else
      update_item_quality(item)
    end
  end

  def update_bsp_quality(item)
    if past_sell_in?(item)
      item.quality = MIN_QUALITY
    else
      bsp_quality_increase_reflects_demand(item)
    end
  end

  def update_brie_quality(item)
    increase_quality_by_one(item)
    increase_quality_by_one(item) if past_sell_in?(item)
  end

  def update_conjured_quality(item)
    CONJURED_MULTIPLIER.times { update_item_quality(item) }
  end

  def update_item_quality(item)
    decrease_quality_by_one(item)
    decrease_quality_by_one(item) if past_sell_in?(item)
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

  def past_sell_in?(item)
    item.sell_in < 0
  end

  def backstage_pass?(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def aged_brie?(item)
    item.name == 'Aged Brie'
  end

  def conjured?(item)
    item.name.downcase.include?('conjured')
  end

  def legendary?(item)
    LEGENDARY_ITEMS.include?(item.name)
  end
end
