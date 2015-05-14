class Cache::Contestant
  def self.all
    ids.map { |c_id| self.new c_id }
  end

  def self.ids
    $redis[:contestants].split ','
  end

  attr_reader :id

  def initialize(contestant_id)
    @id = contestant_id
  end

  def name
    $redis[:"name_#{id}"]
  end

  def avatar_path
    Contestant.avatar_path id
  end

  def vote!
    $redis.incr "votes_#{id}"
  end
end
