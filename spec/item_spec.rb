require 'item'

describe Item do
  describe '#to_s' do
    it 'should format item attributes into a string' do
      item = Item.new('Arsenal', 999, 50)
      expect(item.to_s).to eq('Arsenal, 999, 50')
    end
  end
end
