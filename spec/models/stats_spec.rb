require 'rails_helper'

describe Stats do
  let(:stats) { Stats.new }

  describe 'contestants' do
    it 'returns an array with the contestants and their votes count' do
      create_list :yuri_vote, 2
      result = stats.contestants
      expect(result.count).to eq 2
      expect(result).to include({name: 'Yuri', votes: 2})
      expect(result).to include({name: 'Lais', votes: 0})
    end
  end

  describe 'total' do
    it 'returns the total num of votes records' do
      create_list :vote, 2
      expect(stats.total).to eq 2
    end
  end

  describe 'hourly' do
    it 'return the votes per hour' do
      allow(Vote).to receive(:per_hour) { 'votes per hour' }
      expect(stats.hourly).to eq 'votes per hour'
    end
  end
end
