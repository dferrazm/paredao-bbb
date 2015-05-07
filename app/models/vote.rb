class Vote < ActiveRecord::Base
  validates :contestant_id, presence: true

  def self.per_contestant
    votes = group(:contestant_id).count
    result = {}    
    Contestant.cached_ids.each { |contestant_id| result[contestant_id] = votes[contestant_id.to_i] || 0 }
    result
  end

  def self.per_hour
    group(:time).count
  end
end