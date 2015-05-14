class Cache::Vote < Vote
  attr_reader :contestant

  def initialize(params)
    super params
    @contestant = Cache::Contestant.new contestant_id
  end

  def save
    if valid?
      contestant.vote!
      true
    end
  end
end
