require 'rails_helper'

describe ContestantStore do
  describe 'self.init_store' do
    it 'initializes redis with host and port' do
      expect(Redis).to receive(:new).with(host: 'localhost', port: 6379) { Hash.new }
      subject.class.init_store
    end

    it 'initializes a $redis instance' do
      subject.class.init_store
      expect($redis).to_not be_nil
    end

    it 'caches the contestant ids' do
      contestant = create :contestant
      subject.class.init_store
      expect($redis[:contestants]).to eq "1,2,#{contestant.id}"
    end

    it 'loads the votes for each contestant' do
      create_list :first_contestant_vote, 2
      create_list :second_contestant_vote, 1
      subject.class.init_store
      expect($redis[:votes_1]).to eq '2'
      expect($redis[:votes_2]).to eq '1'
    end
  end

  describe 'methods' do
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
      end
    end

    describe 'self.remove' do
      it 'updates the redis value regarding the added contestant' do
        contestant = build :contestant, id: 45
        $redis[:contestants] = '1,45,2'
        $redis[:votes_45] = '0'
        subject.class.remove contestant
        expect($redis[:contestants]).to eq '1,2'
        expect($redis[:votes_45]).to be_nil
      end
    end

    describe 'self.votes' do
      it 'returns the number of votes for a contestant stored in redis' do
        $redis[:votes_1] = 7
        $redis[:votes_3] = 3
        expect(ContestantStore.votes 1).to eq 7
        expect(ContestantStore.votes 3).to eq 3
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
end
