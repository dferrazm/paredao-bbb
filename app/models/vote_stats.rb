class VoteStats
  def self.total_per_contestant
    Vote.per_contestant
  end

  def self.total_per_hour
    Vote.per_hour
  end

  def self.percentage
    contestant_votes = votes_per_contestant
    total = contestant_votes.values.sum
    greater = contestant_votes.first[0] # first key
    contestant_votes.each_key do |cont|
      contestant_votes[cont] = ((contestant_votes[cont] / (total.zero? ? 1 : total).to_d) * 100).round.to_i
      greater = cont if contestant_votes[cont] > contestant_votes[greater]
    end
    { percentages: contestant_votes, greater: greater }.to_json
  end

  private

  def self.votes_per_contestant
    result = {}
    MyCache.ids.each { |id| result[id] = MyCache.votes id }
    result
  end
end
