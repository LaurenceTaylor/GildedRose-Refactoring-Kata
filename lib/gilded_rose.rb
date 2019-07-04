require 'item'

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if !special?(item)
        item.quality -= 1 if item.quality > 0
      else
        update_bsp_quality(item)
        update_brie_quality(item)
      end

      # update sell_in for all but Sulfuras
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end

      # past sell_in
      if item.sell_in < 0
        # item quality decrease by 1 each day for most items, barring sulfuras etc
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            # item quality becomes 0 if tickets
            item.quality = item.quality - item.quality
          end
        end
      end
    end
  end

  private

  def special?(item)
    ['Aged Brie', 'Backstage passes to a TAFKAL80ETC concert',
     'Sulfuras, Hand of Ragnaros'].include?(item.name)
  end

  # def update_quality(item)
  #   item.quality -= 1 if item.quality > 0
  #   item.quality -= 1 if item.quality > 0 && item.sell_in < 0
  #   item.sell_in -= 1
  # end

  def update_bsp_quality(item)
    if item.name == 'Backstage passes to a TAFKAL80ETC concert'
      item.quality += 1 if item.quality < 50
      item.quality += 1 if item.quality < 50 && item.sell_in < 11
      item.quality += 1 if item.quality < 50 && item.sell_in < 6
    end
  end

  def update_brie_quality(item)
    if item.name == 'Aged Brie'
      item.quality += 1 if item.quality < 50
      item.quality += 1 if item.sell_in < 0
    end
  end
end
