class VoteRecorder
  def initialize(contestant)
    @contestant = contestant
  end

  # bulk insert all the votes data from redis to the db
  def self.flush
    Contestant.cached_ids.each { |contestant_id| flush_contestant contestant_id }
  end

  def self.finish
    ENV['FINISH']
  end

  private

  def self.flush_contestant(id)
    # get the total votes for the contestant until now
    total_votes = ContestantsStore.votes id
    # calculate the number of votes to be inserted (the difference between the total votes and the flushed already)
    count = total_votes - ContestantsStore.flushed_votes(id)
    # bulk insert all the votes to the db
    unless count.zero?
      # calculate the time to set for the votes
      time = Time.now.strftime('%Y-%m-%d %H:00')
      # the values to be inserted in the votes table
      value = "(#{id},'#{time}'),"
      # bulk insert all the votes to the db
      Vote.connection.execute "INSERT INTO votes (`contestant_id`,`time`) VALUES #{(value * count)[0..-2]}" # [0..-2] remove the last comma
      # update the flushed votes with the total votes so far
      ContestantsStore.flush_votes! id, total_votes
    end
  end
end
