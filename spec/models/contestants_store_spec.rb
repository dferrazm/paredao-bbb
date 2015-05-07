require 'rails_helper'

describe ContestantsStore do
  describe 'init' do
    it 'initializes redis with host and port' do
      expect(Redis).to receive(:new).with(host: 'localhost', port: 6379) { Hash.new }
      subject.class.init
    end

    it 'initializes a $redis instance' do
      subject.class.init
      expect($redis).to_not be_nil
    end

    it 'caches the contestant ids' do
      contestant = create :contestant
      subject.class.init
      expect($redis[:contestants]).to eq "1,2,#{contestant.id}"
    end

    it 'loads the votes for each contestant' do
      create_list :first_contestant_vote, 2
      create_list :second_contestant_vote, 1
      subject.class.init
      expect($redis[:votes_1]).to eq '2'
      expect($redis[:flushed_1]).to eq '2'
      expect($redis[:votes_2]).to eq '1'
      expect($redis[:flushed_2]).to eq '1'
    end
  end

  context 'utility methods' do
    before do
      clear_redis
    end

    describe 'votes' do
      it 'returns the number of votes for a contestant stored in redis' do
        $redis[:votes_1] = 7
        $redis[:votes_3] = 3
        expect(ContestantsStore.votes 1).to eq 7
        expect(ContestantsStore.votes 3).to eq 3
      end
    end

    describe 'flushed_votes' do
      it 'returns the number of flushed votes for a contestant stored in redis' do
        $redis[:flushed_1] = 2
        $redis[:flushed_3] = 1
        expect(ContestantsStore.flushed_votes 1).to eq 2
        expect(ContestantsStore.flushed_votes 3).to eq 1
      end
    end

    describe 'flush_votes!' do
      it 'updates the flushed votes counter for the contestant in redis' do
        subject.class.flush_votes! 1, 10
        expect($redis[:flushed_1]).to eq '10'
        subject.class.flush_votes! 2, 7
        expect($redis[:flushed_2]).to eq '7'
      end
    end

    describe 'add' do
      it 'updates the redis value regarding the added contestant' do
        contestant = build :contestant, id: 45
        subject.class.add contestant
        expect($redis[:contestants]).to eq '1,2,45'
        expect($redis[:votes_45]).to eq '0'
        expect($redis[:flushed_45]).to eq '0'
      end
    end

    describe 'remove' do
      it 'updates the redis value regarding the added contestant' do
        contestant = build :contestant, id: 45
        $redis[:contestants] = '1,45,2'
        $redis[:votes_45] = '0'
        $redis[:flushed_45] = '0'
        subject.class.remove contestant
        expect($redis[:contestants]).to eq '1,2'
        expect($redis[:votes_45]).to be_nil
        expect($redis[:flushed_45]).to be_nil
      end
    end
  end
end
