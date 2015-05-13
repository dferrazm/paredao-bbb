class Admin::StatsController < Admin::ApplicationController

  def index
    @stats = Stats.new
  end

  def hourly
    render json: Vote.per_hour
  end
end
