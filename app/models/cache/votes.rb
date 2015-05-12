class Cache::Votes
  def initialize(contestant_id)
    @contestant_id = contestant_id
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

  def self.flush_all
    MyCache.ids.each do |id|
      votes = self.new id
      votes.flush
    end
  end

  def flush
    amount = count - persisted_count
    Vote.create_many(amount, @contestant_id) if amount > 0
  end

  def count
    MyCache.votes @contestant_id
  end

  def persisted_count
    Vote.count_for @contestant_id
  end

  private

  def self.votes_per_contestant
    result = {}
    MyCache.ids.each { |id| result[id] = MyCache.votes id }
    result
  end
end
