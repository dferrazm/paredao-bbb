class Cache::Votes
  def initialize(contestant_id)
    @contestant_id = contestant_id
  end

  def self.flush_all
    MyCache.ids.each do |id|
      votes = self.new id
      votes.flush
    end
  end

  def flush
    amount = count - persisted_count
    Vote.save_many(amount, @contestant_id) unless amount.zero?
  end

  def count
    MyCache.votes @contestant_id
  end

  def persisted_count
    Vote.count_for @contestant_id
  end
end
