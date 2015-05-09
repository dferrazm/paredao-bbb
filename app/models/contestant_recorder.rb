class ContestantRecorder

	def self.destroy(contestant)
		ContestantsStore.remove contestant
		contestant.destroy
	end
end
