require 'rails_helper'

describe Vote do
  it 'has a valid factory' do
    expect(build :vote).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a contestant' do
      expect(build :vote, contestant_id: nil).to_not be_valid
    end
  end

  describe 'methods' do
    describe 'per_contestant' do
      it 'returns 0 for each contestant when there are no votes' do
        expect(Vote.per_contestant).to eq({ first_contestant_id.to_s => 0, second_contestant_id.to_s => 0 })
      end

      it 'returns the total votes for each contestant' do
        create_list :first_contestant_vote, 1
        create_list :second_contestant_vote, 3
        expect(Vote.per_contestant).to eq({ first_contestant_id.to_s => 1, second_contestant_id.to_s => 3 })
      end
    end

    describe 'per_hour' do
      it 'returns empty for when there are no votes' do
        expect(Vote.per_hour).to eq({})
      end

      it 'returns the total votes for each hour' do
        create_list :first_contestant_vote, 1, time: '2014-10-13 12:00'
        create_list :second_contestant_vote, 3, time: '2014-10-13 14:00'
        expect(Vote.per_hour).to eq({ '2014-10-13 12:00' => 1, '2014-10-13 14:00' => 3 })
      end
    end
  end
end