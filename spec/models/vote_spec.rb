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
    describe 'count_for' do
      it 'returns 0 when contestant has no votes' do
        expect(Vote.count_for first_contestant_id).to eq 0
      end

      it 'returns the number of votes for a given contestant' do
        create_list :first_contestant_vote, 2
        create_list :second_contestant_vote, 1
        expect(Vote.count_for first_contestant_id).to eq 2
      end
    end

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

    describe 'save_many' do
      it 'saves a given amount of vote for the target contestant' do
        allow(Time).to receive_message_chain(:zone, :now) { Time.new 2015,4,10,9,23,22 }
        expect { Vote.save_many 2, first_contestant_id }.to change(Vote, :count).by(2)
        Vote.all.each do |v|
          expect(v.contestant_id).to eq first_contestant_id
          expect(v.time).to eq '2015-04-10 09:00'
        end
      end
    end
  end
end
