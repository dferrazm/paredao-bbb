require 'rails_helper'

describe Cache::Vote do
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
end
