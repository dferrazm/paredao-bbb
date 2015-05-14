require 'rails_helper'

describe Cache::Vote do
  describe 'save' do
    context 'valid contestant votes' do
      before do
        @vote = Cache::Vote.new contestant_id: first_contestant_id
      end

      it 'initializes the cached contestant' do
        expect(@vote.contestant).to_not be_nil
        expect(@vote.contestant.class).to eq Cache::Contestant
        expect(@vote.contestant.id).to eq first_contestant_id
      end

      it 'increments the votes cache for the contestant' do
        expect(@vote.contestant).to receive(:vote!)
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
end
