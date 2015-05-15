require 'rails_helper'

describe Poll do
  let(:poll) { Poll.instance }
  let(:anytime) { Time.now }

  describe 'start' do
    it 'updated the deadline and returns tryue' do
      expect(poll.start '2015-10-11 09:00:00 UTC').to be_truthy
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

    it 'returns false on nil or invalid deadlines' do
      expect(poll.start nil).to be_falsy
      expect(poll.start 'invalid').to be_falsy
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
      poll.instance_variable_set '@deadline', Time.parse('2015-02-11 09:00:00')
      now = Time.parse '2015-02-11 10:00:00'
      allow(Time).to receive(:now) { now }
      expect(poll.finished?).to be_truthy
    end

    it 'returns true when deadline nil' do
      poll.instance_variable_set '@deadline', nil
      $redis[:deadline] = nil
      expect(poll.finished?).to be_truthy
    end

    it 'returns false when deadline greater than now' do
      poll.instance_variable_set '@deadline', Time.parse('2015-02-11 10:00:00')
      now = Time.parse '2015-02-11 09:00:00'
      allow(Time).to receive(:now) { now }
      expect(poll.finished?).to be_falsy
    end
  end

  describe 'deadline' do
    it 'returns the @deadline' do
      poll.instance_variable_set '@deadline', Time.parse('2014-10-11 10:00:00 UTC')
      $redis[:deadline] = '2014-10-10 10:00:00 UTC'
      expect(poll.deadline).to eq Time.parse('2014-10-11 10:00:00 UTC')
    end

    it 'tries to load from cache when @deadline nil' do
      poll.instance_variable_set '@deadline', nil
      $redis[:deadline] = '2014-10-10 10:00:00 UTC'
      expect(poll.deadline).to eq Time.parse('2014-10-10 10:00:00 UTC')
    end
  end
end
