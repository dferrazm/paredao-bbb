require 'rails_helper'

describe VoteStore do
  describe 'methods' do
    before do
      clear_redis
    end

    describe 'save' do
      context 'valid contestant votes' do
        before do
          @vote = VoteStore.new contestant_id: first_contestant_id
        end

        it 'increments the votes counter for the contestant' do
          @vote.save
          expect($redis[:"votes_#{first_contestant_id}"]).to eq '1'
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
          @vote = VoteStore.new contestant_id: nil
        end

        it 'does not persist the vote' do
          expect { @vote.save }.to_not change(Vote, :count)
        end

        it 'returns false' do
          expect(@vote.save).to be_falsy
        end
      end
    end
  end
end
