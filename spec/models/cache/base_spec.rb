require 'rails_helper'

describe Cache::Base do
  describe 'self.init' do
    it 'initializes redis with host and port' do
      expect(Redis).to receive(:new).with(host: 'localhost', port: 6379) { Hash.new }
      Cache::Base.init
    end

    it 'initializes a $redis instance' do
      Cache::Base.init
      expect($redis).to_not be_nil
    end

    it 'loads the all the required contestants info to the cache' do
      contestant = create :contestant
      create_list :lais_vote, 1
      create_list :yuri_vote, 2

      Cache::Base.init

      expect($redis[:contestants]).to eq "1,2,#{contestant.id}"
      expect($redis[:votes_1]).to eq '1'
      expect($redis[:votes_2]).to eq '2'
      expect($redis[:"votes_#{contestant.id}"]).to eq '0'
      expect($redis[:name_1]).to eq 'Lais'
      expect($redis[:name_2]).to eq 'Yuri'
    end
  end

  describe 'methods' do
    before do
      clear_redis
    end

    describe 'self.add' do
      it 'updates the redis value regarding the added contestant' do
        contestant = build :contestant, id: 45
        Cache::Base.add contestant
        expect($redis[:contestants]).to eq '1,2,45'
        expect($redis[:votes_45]).to eq '0'
      end
    end

    describe 'self.remove' do
      it 'updates the redis value regarding the added contestant' do
        contestant = build :contestant, id: 45
        $redis[:contestants] = '1,45,2'
        $redis[:votes_45] = '0'
        Cache::Base.remove contestant
        expect($redis[:contestants]).to eq '1,2'
        expect($redis[:votes_45]).to be_nil
      end
    end

    describe 'self.votes' do
      it 'returns the number of votes for a contestant stored in redis' do
        $redis[:votes_1] = 7
        $redis[:votes_3] = 3
        expect(Cache::Base.votes 1).to eq 7
        expect(Cache::Base.votes 3).to eq 3
      end
    end
  end
end
