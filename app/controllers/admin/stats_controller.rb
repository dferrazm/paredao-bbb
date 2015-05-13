class Admin::StatsController < Admin::ApplicationController
  before_action :set_stats

  def index;end

  def hourly
    render json: @stats.hourly
  end

  private

  def set_stats
    @stats = Stats.new
  end
end
