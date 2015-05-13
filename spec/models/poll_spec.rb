require 'rails_helper'

describe Poll do
  let(:poll) { Poll.instance }
  let(:anytime) { Time.now }

  describe 'start' do
    it 'updated the deadline' do
      poll.start Time.parse('2015-10-11 09:00:00 UTC')
      expect($redis[:deadline]).to eq '2015-10-11 09:00:00 UTC'
    end

    it 'init the cache' do
      expect(Cache::Base).to receive(:init)
      poll.start anytime
    end

    it 'destroys all the votes' do
      create_list :vote, 3
      poll.start anytime
      expect(Vote.count).to eq 0
    end
  end

  describe 'stop' do
    it 'updates the deadline with the current time' do
      now = Time.parse '2015-02-11 09:30:00 UTC'
      allow(Time).to receive(:now) { now }
      poll.stop
      expect($redis[:deadline]).to eq '2015-02-11 09:30:00 UTC'
    end
  end

  describe 'finished?' do
    it 'returns true when deadline lesser than now' do
      $redis[:deadline] = '2015-02-11 09:00:00'
      now = Time.parse '2015-02-11 10:00:00'
      allow(Time).to receive(:now) { now }
      expect(poll.finished?).to be_truthy
    end

    it 'returns true when deadline nil' do
      $redis[:deadline] = nil
      expect(poll.finished?).to be_truthy
    end

    it 'returns false when deadline greater than now' do
      $redis[:deadline] = '2015-02-11 10:00:00'
      now = Time.parse '2015-02-11 09:00:00'
      allow(Time).to receive(:now) { now }
      expect(poll.finished?).to be_falsy
    end
  end
end
