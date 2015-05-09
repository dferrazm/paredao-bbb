require 'rails_helper'

describe MyCache do
  describe 'self.init' do
    it 'initializes redis with host and port' do
      expect(Redis).to receive(:new).with(host: 'localhost', port: 6379) { Hash.new }
      MyCache.init
    end

    it 'initializes a $redis instance' do
      MyCache.init
      expect($redis).to_not be_nil
    end

    it 'caches the contestant ids' do
      contestant = create :contestant
      MyCache.init
      expect($redis[:contestants]).to eq "1,2,#{contestant.id}"
    end

    it 'loads the votes for each contestant' do
      create_list :first_contestant_vote, 2
      create_list :second_contestant_vote, 1
      MyCache.init
      expect($redis[:votes_1]).to eq '2'
      expect($redis[:votes_2]).to eq '1'
    end
  end

  describe 'methods' do
    before do
      clear_redis
    end

    describe 'self.add' do
      it 'updates the redis value regarding the added contestant' do
        contestant = build :contestant, id: 45
        MyCache.add contestant
        expect($redis[:contestants]).to eq '1,2,45'
        expect($redis[:votes_45]).to eq '0'
      end
    end

    describe 'self.remove' do
      it 'updates the redis value regarding the added contestant' do
        contestant = build :contestant, id: 45
        $redis[:contestants] = '1,45,2'
        $redis[:votes_45] = '0'
        MyCache.remove contestant
        expect($redis[:contestants]).to eq '1,2'
        expect($redis[:votes_45]).to be_nil
      end
    end

    describe 'self.votes' do
      it 'returns the number of votes for a contestant stored in redis' do
        $redis[:votes_1] = 7
        $redis[:votes_3] = 3
        expect(MyCache.votes 1).to eq 7
        expect(MyCache.votes 3).to eq 3
      end
    end
  end
end
