class VotesController < ApplicationController
  layout 'poll'

  before_action :check_finish, only: [:index, :create]
  before_action :block_bots, only: :create

  def index
    render_index
  end

  def create
    vote = Cache::Vote.new contestant_id: params[:contestant]

    if vote.save
      flash[:success] = I18n.t('votes.create.success')
      render_result
    else
      flash[:error] = I18n.t 'votes.create.error.invalid'
      render_index
    end
  end

  def result
    render_result
  end

  def percentage
    render json: Cache::Votes.percentage
  end

  private

  def check_finish
    if Time.now >= Time.parse(ENV['FINISH'])
      flash[:info] = I18n.t 'votes.result.info.finish'
      redirect_to action: 'result'
    end
  end

  def block_bots
    render_index unless verify_recaptcha
  end

  def render_index
    @contestants_ids = MyCache.ids
    render :index
  end

  def render_result
    @contestants_ids = MyCache.ids
    @finish = ENV['FINISH']
    render :result
  end
end
