require 'rails_helper'

describe Cache::Contestant do
  before do
    clear_redis
  end

  describe 'self.create' do
    it 'persists the contestant and caches it in memory' do
      memory = []
      allow(MyCache).to receive(:add) { |c| memory << c }
      contestant = Cache::Contestant.create name: 'John Doe', id: 45

      expect(contestant.persisted?).to be_truthy
      expect(memory).to eq [contestant]
    end
  end

  describe 'destroy' do
    it 'destroy the persisted contestant and removes it from memory' do
      contestant = Cache::Contestant.create name: 'John Doe'
      memory = [contestant]
      allow(MyCache).to receive(:remove) { |c| memory.delete c }

      expect { contestant.destroy }.to change(Contestant, :count).by(-1)
      expect(memory).to eq []
    end
  end
end
