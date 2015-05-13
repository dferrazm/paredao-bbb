class Cache::Vote < Vote
  def save
    if valid?
      Cache::Base.vote contestant_id
      true
    end
  end
end
