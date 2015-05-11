require 'rails_helper'

describe VoteStats do
  describe 'methods' do
    describe 'percentage' do
      before do
        clear_redis
      end

      it 'returns 0 for each contestant when there are no votes' do
        expect(VoteStats.percentage).to eq({ percentages: { '1' => 0, '2' => 0 }, greater: '1'}.to_json)
      end

      it 'returns the percentage of each contestant based on the cached counters' do
        allow(MyCache).to receive(:votes).with('1') { 1 } # 25 %
        allow(MyCache).to receive(:votes).with('2') { 3 } # 75 %
        expect(VoteStats.percentage).to eq({ percentages: { '1' => 25, '2' => 75 }, greater: '2'}.to_json)
      end

      it 'rounds up the percentage and returns integer numbers' do
        allow(MyCache).to receive(:votes).with('1') { 2 } # 29 %
        allow(MyCache).to receive(:votes).with('2') { 5 } # 71 %
        expect(VoteStats.percentage).to eq({ percentages: { '1' => 29, '2' => 71 }, greater: '2'}.to_json)
      end
    end
  end
end
