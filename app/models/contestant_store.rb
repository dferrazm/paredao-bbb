class ContestantStore < Contestant
  def self.create(params)
    contestant = super params
    contestant.tap { |cont| add cont if cont.persisted? }
  end

  def self.ids
    $redis[:contestants].split ','
  end

  def self.add(contestant)
    $redis[:contestants] = (ids << contestant.id).join ','
    $redis["votes_#{contestant.id}"] = 0
    $redis["flushed_#{contestant.id}"] = 0
  end

  def self.remove(contestant)
    current_ids = ids
    current_ids.delete contestant.id.to_s
    $redis[:contestants] = current_ids.join ','
    $redis.del "votes_#{contestant.id}"
    $redis.del "flushed_#{contestant.id}"
  end

  def destroy
    super
    self.class.remove self
  end  
end
