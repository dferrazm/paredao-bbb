class VoteStore < Vote
  def save
    if valid?
      $redis.incr "votes_#{contestant_id}"
      true
    end
  end
end
