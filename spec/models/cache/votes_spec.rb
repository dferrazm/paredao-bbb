require 'rails_helper'

describe Cache::Votes do
  describe 'self.percentage' do
    before do
      clear_redis
    end

    it 'returns 0 for each contestant when there are no votes' do
      expect(Cache::Votes.percentage).to eq({ percentages: { '1' => 0, '2' => 0 }, greater: '1'}.to_json)
    end

    it 'returns the percentage of each contestant based on the cached counters' do
      cont_1 = double id: '1', votes_count: 1 # 25 %
      cont_2 = double id: '2', votes_count: 3 # 75 %
      allow(Cache::Contestant).to receive(:all) { [cont_1, cont_2] }

      expect(Cache::Votes.percentage).to eq({ percentages: { '1' => 25, '2' => 75 }, greater: '2'}.to_json)
    end

    it 'rounds up the percentage and returns integer numbers' do
      cont_1 = double id: '1', votes_count: 2 # 28,XX %
      cont_2 = double id: '2', votes_count: 5 # 71,XX %
      allow(Cache::Contestant).to receive(:all) { [cont_1, cont_2] }

      expect(Cache::Votes.percentage).to eq({ percentages: { '1' => 29, '2' => 71 }, greater: '2'}.to_json)
    end
  end

  describe 'flush' do
    before do
      @bulk_insert = nil
      allow(Vote).to receive_message_chain(:connection, :execute) { |sql| @bulk_insert = sql }
      allow(Time).to receive(:now) { Time.new 2014,10,13,12,37,55 }
    end

    it 'bulk inserts all the votes data from contestants store to the db' do
      expect(Vote).to receive(:create_many).with(2, 1) # amount, contestant_id
      flush 3, 1
    end

    it 'inserts nothing when amount 0' do
      expect(Vote).to_not receive(:create_many)
      flush 1, 1
    end

    it 'inserts nothing when amount < 0' do
      expect(Vote).to_not receive(:create_many)
      flush 0, 1
    end

    def flush(cache_count, persisted_count)
      vote = Cache::Votes.new 1
      allow(vote).to receive(:persisted_count) { persisted_count }
      allow(vote).to receive(:count) { cache_count }
      vote.flush
    end
  end

  describe 'count' do
    it 'returns the number of votes count in memory for the target contestant' do
      votes = Cache::Votes.new 2
      expect(votes.contestant).to receive(:votes_count)
      votes.count
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
