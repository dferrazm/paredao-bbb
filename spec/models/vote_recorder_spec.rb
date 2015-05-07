require 'rails_helper'

describe VoteRecorder do
  describe 'methods' do
    before do
      clear_redis
    end

    describe 'record' do
      context 'valid contestant votes' do
        before do
          @recorder = VoteRecorder.new first_contestant_id
        end

        it 'increments the votes counter for the contestant in the contestants store' do
          expect(ContestantsStore).to receive(:vote!).with(first_contestant_id)
          @recorder.record
        end

        it 'does not persist the vote' do
          expect { @recorder.record }.to_not change(Vote, :count)
        end

        it 'returns true' do
          expect(@recorder.record).to be_truthy
        end
      end

      context 'invalid contestant votes' do
        before do
          @recorder = VoteRecorder.new nil
        end

        it 'does not persist the vote' do
          expect { @recorder.record }.to_not change(Vote, :count)
        end

        it 'returns false' do
          expect(@recorder.record).to be_falsy
        end
      end
    end

    describe 'flush' do
      let(:stub_votes) {
        allow(ContestantsStore).to receive(:votes).with('1') { 10 }
        allow(ContestantsStore).to receive(:flushed_votes).with('1') { 8 }
        allow(ContestantsStore).to receive(:votes).with('2') { 0 }
        allow(ContestantsStore).to receive(:flushed_votes).with('2') { 0 }
      }

      before do
        @bulk_insert = nil
        allow(Vote).to receive_message_chain(:connection, :execute) { |sql| @bulk_insert = sql }
        allow(Time).to receive(:now) { Time.new 2014,10,13,12,37,55 }
      end

      it 'bulk inserts all the votes data from contestants store to the db' do
        stub_votes
        VoteRecorder.flush
        # inserts two votes for the contestant with id 1 in time now
        expect(@bulk_insert).to eq "INSERT INTO votes (`contestant_id`,`time`) VALUES (1,'2014-10-13 12:00'),(1,'2014-10-13 12:00')"
      end

      it 'updates the number of flushed votes stored in redis' do
        stub_votes
        expect(ContestantsStore).to receive(:flush_votes!).with('1', 10)
        VoteRecorder.flush
      end

      it 'generates no sql insert then there are no votes data' do
        VoteRecorder.flush
        expect(@bulk_insert).to be_nil
      end
    end

    describe 'finish' do
      it 'returns the finish time from env' do
        ENV['FINISH'] = '2015-01-01 14:57'
        expect(VoteRecorder.finish).to eq '2015-01-01 14:57'
      end
    end
  end
end