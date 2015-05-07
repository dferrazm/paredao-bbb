class ContestantsStore
  def self.init
    $redis = Redis.new host: 'localhost', port: 6379
    begin
      $redis[:contestants] = Contestant.ids.join ','
      votes = Vote.per_contestant
      votes.each { |id, count| $redis["votes_#{id}"] = $redis["flushed_#{id}"] = count }
    rescue => e
      puts "Error when initing redits keys. Your DB may not be migrated yet: #{e.message}"
      $redis[:contestants] = ''
    end
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

  def self.votes(contestant_id)
    $redis["votes_#{contestant_id}"].to_i
  end

  def self.flushed_votes(contestant_id)
    $redis["flushed_#{contestant_id}"].to_i
  end

  def self.flush_votes!(contestant_id, votes)
    $redis["flushed_#{contestant_id}"] = votes
  end
end
