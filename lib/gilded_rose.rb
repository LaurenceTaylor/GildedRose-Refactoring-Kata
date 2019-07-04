require 'item'

class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      # if not brie or tickets, decrease item quality until you get to 0
      if !special?(item)
        item.quality -= 1 if item.quality > 0
      else
        # if not sulfuras, but brie or tickets then quality increases up to 50
        if item.quality < 50
          item.quality = item.quality + 1
          # tickets increase in quality again (2) if < 11 days until sell_in
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            # tickets increase in quality again (3) if < 6 days until sell_in
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
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
        else
          # item quality increases if brie
          if item.quality < 50
            item.quality = item.quality + 1
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

  def update_bsp_quality(bsp)
    item.quality += 1 if item.quality < 50
    item.quality += 1 if item.quality < 50 && item.sell_in < 11
    item.quality += 1 if item.quality < 50 && item.sell_in < 6
  end

  def update_brie_quality(brie)
    item.quality += 1 if item.quality < 50
  end
end
