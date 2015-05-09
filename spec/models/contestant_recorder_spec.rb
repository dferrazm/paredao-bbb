require 'rails_helper'

describe ContestantRecorder do

	describe 'destroy' do
		it 'removes the contestant to the contestant store' do
			contestant = contestants(:first)
			expect(ContestantsStore).to receive(:remove).with(contestant)
			ContestantRecorder.destroy contestant
		end

		it 'destroy the contestant votes' do
			create_list :first_contestant_vote, 2
			contestant = contestants(:first)
			allow(ContestantsStore).to receive(:remove) { true }
			expect { ContestantRecorder.destroy contestant }.to change(Vote, :count).by(-2)
		end

		it 'destroys the contestant' do
			allow(ContestantsStore).to receive(:remove) { true }
			expect { ContestantRecorder.destroy contestants(:first) }.to change(Contestant, :count).by(-1)
		end
	end
end
