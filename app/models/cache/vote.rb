class Cache::Vote < Vote
  def self.flush_all
    MyCache.ids.each do |id|
      vote = self.new contestant_id: id
      vote.flush
    end
  end

  def save
    if valid?
      MyCache.vote contestant_id
      true
    end
  end

  def flush
    amount = count - persisted_count
    save_many(amount) unless amount.zero?
  end

  def count
    MyCache.votes contestant_id
  end

  def persisted_count
    self.class.count_for contestant_id
  end
end
