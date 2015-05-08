class VoteStore < Vote
  def self.flush_all
    Contestant.cached_ids.each do |id|
      vote = self.new contestant_id: id
      vote.flush
    end
  end

  def save
    if valid?
      $redis.incr "votes_#{contestant_id}"
      true
    end
  end

  def flush
    amount = count - persisted_count
    save_many(amount) unless amount.zero?
  end

  def count
    $redis["votes_#{contestant_id}"].to_i
  end

  def persisted_count
    self.class.count_for contestant_id
  end
end
