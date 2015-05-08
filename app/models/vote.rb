class Vote < ActiveRecord::Base
  validates :contestant_id, presence: true

  def self.count_for(contestant_id)
    where(contestant_id: contestant_id).count
  end

  def self.per_contestant
    votes = group(:contestant_id).count
    result = {}
    Contestant.cached_ids.each { |contestant_id| result[contestant_id] = votes[contestant_id.to_i] || 0 }
    result
  end

  def self.per_hour
    group(:time).count
  end

  def save_many(amount)
    # calculate the time to set for the votes
    time = Time.zone.now.strftime '%Y-%m-%d %H:00'
    # the values to be inserted in the votes table
    values = "(#{contestant_id},'#{time}')," * amount
    # bulk insert all the votes to the db
    self.class.connection.execute "INSERT INTO votes (`contestant_id`,`time`) VALUES #{values.chop}"
  end
end
