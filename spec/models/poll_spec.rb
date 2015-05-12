require 'rails_helper'

describe Poll do
  before do
    @player = Poll.new
  end

  let(:anytime) { Time.now }

  describe 'start' do
    it 'updated the deadline' do
      @player.start Time.parse('2015-10-11 09:00:00 UTC')
      expect($redis[:deadline]).to eq '2015-10-11 09:00:00 UTC'
    end

    it 'init the cache' do
      expect(MyCache).to receive(:init)
      @player.start anytime
    end

    it 'destroys all the votes' do
      create_list :vote, 3
      @player.start anytime
      expect(Vote.count).to eq 0
    end
  end

  describe 'stop' do
    it 'updates the deadline with the current time' do
      now = Time.parse '2015-02-11 09:30:00 UTC'
      allow(Time).to receive(:now) { now }
      @player.stop
      expect($redis[:deadline]).to eq '2015-02-11 09:30:00 UTC'
    end
  end
end
