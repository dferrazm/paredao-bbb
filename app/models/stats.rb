class Stats
  def contestants
    @contestants ||= get_stats_for_each_contestant
  end

  def total
    @total ||= Vote.count
  end

  def hourly
    @hourly ||= Vote.per_hour
  end

  private

  def get_stats_for_each_contestant
    per_contestant = Vote.per_contestant
    Contestant.all.each_with_object([]) do |contestant, array|
      array << { name: contestant.name, votes: per_contestant[contestant.id] }
    end
  end
end
