require 'rails_helper'

describe ContestantStore do
  before do
    clear_redis
  end

  describe 'self.create' do
    it 'persists the contestant and caches its id in memory' do
      cached_ids = $redis[:contestants]
      contestant = ContestantStore.create name: 'John Doe'
      expect(contestant.persisted?).to be_truthy
      new_cached_id = $redis[:contestants].gsub "#{cached_ids},", ''
      expect(new_cached_id).to eq contestant.id.to_s
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
end
