class Admin::StatsController < Admin::ApplicationController

  def index
    @stats = Vote.per_contestant
    @total = @stats.values.inject { |sum, total| sum + total }
  end

  def hourly
    render json: Vote.per_hour
  end
end
