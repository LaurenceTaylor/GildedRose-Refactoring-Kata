require 'gilded_rose'
require 'helpers'

describe GildedRose do
  let(:default_quality) { 20 }

  describe '#update_quality' do
    context 'in most cases: not brie, backstage passes, or Sulfuras' do
      it 'does not change the name' do
        items = [Item.new('foo', 0, 0)]
        update(items)
        expect(items[0].name).to eq 'foo'
      end

      it 'should reduce item quality by 1 unless brie/ BSP (backstage pass)' do
        items = [Item.new('Orange Juice', 7, default_quality)]
        update(items)
        expect(items[0].quality).to eq(default_quality - 1)
      end

      it 'should not reduce item quality if already at 0' do
        init_quality = 0
        items = [Item.new('Tottenham Hotspur', 7, init_quality)]
        update(items)
        expect(items[0].quality).to eq(init_quality)
      end

      it 'degrades twice as fast if past its sell by' do
        items = [Item.new('Tottenham Hotspur', 0, default_quality)]
        update(items)
        expect(items[0].quality).to eq(default_quality - 2)
      end
    end

    context 'if item is Aged Brie' do
      it 'should increase item quality by 1' do
        items = [Item.new('Aged Brie', 15, default_quality)]
        update(items)
        expect(items[0].quality).to eq(default_quality + 1)
      end

      it 'should not increase quality if already at 50' do
        init_quality = 50
        items = [Item.new('Aged Brie', 15, init_quality)]
        update(items)
        expect(items[0].quality).to eq(init_quality)
      end
    end

    context 'if item is a backstage pass' do
      it 'should normally increase item quality by 1' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',
                          15, default_quality)]

        update(items)
        expect(items[0].quality).to eq(default_quality + 1)
      end

      it 'should increase item quality by 2 if <= 10 days to go' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',
                          9, default_quality)]

        update(items)
        expect(items[0].quality).to eq(default_quality + 2)
      end

      it 'should increase item quality by 3 if <= 5 days to go' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',
                          4, default_quality)]

        update(items)
        expect(items[0].quality).to eq(default_quality + 3)
      end

      it 'should have quality drop to 0 after the gig' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert',
                          0, default_quality)]

        update(items)
        expect(items[0].quality).to eq(0)
      end
    end

    context 'if item is Sulfuras' do
      it 'should not change quality' do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 80)]
        update(items)
        expect(items[0].quality).to eq(80)
      end

      it 'should not change sell_in' do
        items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 80)]
        update(items)
        expect(items[0].sell_in).to eq(10)
      end
    end

    context 'if item is Conjured' do
      it 'should degrade twice as fast as a normal item' do
        items = [Item.new('Conjured', 20, default_quality)]
        update(items)
        expect(items[0].quality).to eq(18)
      end
    end
  end
end
