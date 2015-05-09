require 'rails_helper'

describe ContestantStore do
  before do
    clear_redis
  end

  describe 'self.create' do
    it 'persists the contestant and caches its id in memory' do
      cached_ids = $redis[:contestants]
      contestant = ContestantStore.create name: 'John Doe'
      new_cached_id = $redis[:contestants].gsub "#{cached_ids},", ''

      expect(contestant.persisted?).to be_truthy
      expect(new_cached_id).to eq contestant.id.to_s
      expect($redis["votes_#{contestant.id}"]).to eq '0'
    end
  end

  describe 'self.add' do
    it 'updates the redis value regarding the added contestant' do
      contestant = build :contestant, id: 45
      subject.class.add contestant
      expect($redis[:contestants]).to eq '1,2,45'
      expect($redis[:votes_45]).to eq '0'
      expect($redis[:flushed_45]).to eq '0'
    end
  end

  describe 'destroy' do
    it 'destroy the persisted contestant and removes it from memory cache' do
      original_cached_ids = $redis[:contestants]
      contestant = ContestantStore.create name: 'John Doe'
      expect { contestant.destroy }.to change(Contestant, :count).by(-1)
      expect($redis[:contestants]).to eq original_cached_ids
      expect($redis["votes_#{contestant.id}"]).to be_nil
    end
  end
end
