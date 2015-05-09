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
end
