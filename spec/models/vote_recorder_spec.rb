require 'rails_helper'

describe VoteRecorder do
  describe 'methods' do
    describe 'finish' do
      it 'returns the finish time from env' do
        ENV['FINISH'] = '2015-01-01 14:57'
        expect(VoteRecorder.finish).to eq '2015-01-01 14:57'
      end
    end
  end
end
