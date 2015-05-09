require 'rails_helper'

describe Cache::Vote do
  describe 'methods' do
    before do
      clear_redis
    end

    describe 'save' do
      context 'valid contestant votes' do
        before do
          @vote = Cache::Vote.new contestant_id: first_contestant_id
        end

        it 'increments the votes cache for the contestant' do
          expect(MyCache).to receive(:vote).with @vote.contestant_id
          @vote.save
        end

        it 'does not persist the vote' do
          expect { @vote.save }.to_not change(Vote, :count)
        end

        it 'returns true' do
          expect(@vote.save).to be_truthy
        end
      end

      context 'invalid contestant votes' do
        before do
          @vote = Cache::Vote.new contestant_id: nil
        end

        it 'does not persist the vote' do
          expect { @vote.save }.to_not change(Vote, :count)
        end

        it 'returns false' do
          expect(@vote.save).to be_falsy
        end
      end
    end

    describe 'flush' do
      before do
        @bulk_insert = nil
        allow(Vote).to receive_message_chain(:connection, :execute) { |sql| @bulk_insert = sql }
        allow(Time).to receive(:now) { Time.new 2014,10,13,12,37,55 }
      end

      it 'bulk inserts all the votes data from contestants store to the db' do
        @vote = Cache::Vote.new contestant_id: 1

        # 1 vote in the DB
        allow(@vote).to receive(:persisted_count) { 1 }
        # 3 votes in the memory store
        allow(@vote).to receive(:count) { 3 }

        expect(@vote).to receive(:save_many).with 2
        @vote.flush
      end
    end

    describe 'count' do
      it 'returns the number of votes count in memory for the target contestant' do
        vote = Cache::Vote.new contestant_id: 2
        expect(MyCache).to receive(:votes).with(vote.contestant_id)
        vote.count
      end
    end

    describe 'persisted_count' do
      it 'returns count_for the target contestant' do
        vote = Cache::Vote.new contestant_id: 2
        allow(Vote).to receive(:count_for).with(2) { 10 }
        expect(vote.persisted_count).to eq 10
      end
    end
  end
end
