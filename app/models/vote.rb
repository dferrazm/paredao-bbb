class Vote < ActiveRecord::Base
  validates :contestant_id, presence: true

  def self.count_for(contestant_id)
    where(contestant_id: contestant_id).count
  end

  def self.per_contestant
    votes = group(:contestant_id).count
    Contestant.ids.each_with_object({}) do |contestant_id, h|
      h[contestant_id] = votes[contestant_id] || 0
    end
  end

  def self.per_hour
    group(:time).count
  end

  def self.create_many(amount, contestant_id)
    # calculate the time to set for the votes
    time = Time.zone.now.strftime '%Y-%m-%d %H:00'
    # the values to be inserted in the votes table
    values = "(#{contestant_id},'#{time}')," * amount
    # bulk insert all the votes to the db
    connection.execute "INSERT INTO votes (`contestant_id`,`time`) VALUES #{values.chop}"
  end
end
