require 'rails_helper'

describe Cache::Votes do
  describe 'flush' do
    before do
      @bulk_insert = nil
      allow(Vote).to receive_message_chain(:connection, :execute) { |sql| @bulk_insert = sql }
      allow(Time).to receive(:now) { Time.new 2014,10,13,12,37,55 }
    end

    it 'bulk inserts all the votes data from contestants store to the db' do
      vote = Cache::Votes.new 1

      # 1 vote in the DB
      allow(vote).to receive(:persisted_count) { 1 }
      # 3 votes in the memory store
      allow(vote).to receive(:count) { 3 }

      expect(Vote).to receive(:save_many).with(2, 1) # amount, contestant_id
      vote.flush
    end
  end

  describe 'count' do
    it 'returns the number of votes count in memory for the target contestant' do
      vote = Cache::Votes.new 2
      expect(MyCache).to receive(:votes).with(2)
      vote.count
    end
  end

  describe 'persisted_count' do
    it 'returns count_for the target contestant' do
      vote = Cache::Votes.new 2
      allow(Vote).to receive(:count_for).with(2) { 10 }
      expect(vote.persisted_count).to eq 10
    end
  end
end
