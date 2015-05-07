class ContestantRecorder
	def self.create(params)
		contestant = Contestant.create params
		ContestantsStore.add contestant if contestant.persisted?
   	contestant
	end

	def self.destroy(contestant)				
		ContestantsStore.remove contestant
		contestant.destroy
	end
end