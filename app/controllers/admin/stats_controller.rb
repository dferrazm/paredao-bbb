class Admin::StatsController < Admin::ApplicationController

  def index
    @stats = VoteStats.total_per_contestant
    @total = @stats.values.inject { |sum, total| sum + total }
  end

  def hourly
    render json: VoteStats.total_per_hour
  end
end
