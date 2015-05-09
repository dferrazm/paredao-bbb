class Cache::Vote < Vote
  def save
    if valid?
      MyCache.vote contestant_id
      true
    end
  end
end
