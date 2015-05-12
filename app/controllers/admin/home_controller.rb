class Admin::HomeController < Admin::ApplicationController
  before_action :set_poll

  def index;end

  def start
    if params[:deadline].present?
      @poll.start(Time.parse params[:deadline])
    else
      flash[:error] = I18n.t 'admin.poll.invalid'
    end

    redirect_to action: 'index'
  end

  def stop
    @poll.stop
    redirect_to action: 'index'
  end

  private

  def set_poll
    @poll = Poll.new
  end
end
