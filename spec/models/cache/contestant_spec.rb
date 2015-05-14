require 'rails_helper'

describe Cache::Contestant do
  let(:contestant) { Cache::Contestant.new 42 }

  it 'initializes the id with the given contestant id' do
    expect(contestant.id).to eq 42
  end

  describe 'name' do
    it 'returns the contestant name from the cache' do
      $redis[:name_42] = 'John Doe'
      expect(contestant.name).to eq 'John Doe'
      $redis[:name_42] = 'Foo Bar'
      expect(contestant.name).to eq 'Foo Bar'
    end
  end

  describe 'avatar_path' do
    it 'returns the Contestant avatar path by its id' do
      allow(Contestant).to receive(:avatar_path).with(42) { '/path/to/avatar' }
      expect(contestant.avatar_path).to eq '/path/to/avatar'
    end
  end

  describe 'self.ids' do
    it 'returns the cached conestant ids as array' do
      $redis[:contestants] = '42,171,172'
      expect(Cache::Contestant.ids).to eq ['42', '171', '172']
    end
  end

  describe 'self.all' do
    it 'initalizes Cache:Contestant for all the cached contestant ids' do
      allow(Cache::Contestant).to receive(:ids) { [42, 171] }
      all = Cache::Contestant.all
      expect(all[0].class).to eq Cache::Contestant
      expect(all[0].id).to eq 42
      expect(all[1].class).to eq Cache::Contestant
      expect(all[1].id).to eq 171
    end
  end
end
