class VotesController < ApplicationController
  before_action :check_finish, only: [:index, :create]
  before_action :block_bots, only: :create

  def index
    render_view :index
  end

  def create
    vote = Cache::Vote.new contestant_id: params[:contestant]

    if vote.save
      flash[:success] = I18n.t('votes.create.success')
      render_view :result
    else
      flash[:error] = I18n.t 'votes.create.error.invalid'
      render_view :index
    end
  end

  def result
    render_view :result
  end

  def percentage
    render json: Cache::Votes.percentage
  end

  private

  def check_finish
    if Poll.finished?
      flash[:info] = I18n.t 'votes.result.info.finish'
      redirect_to action: 'result'
    end
  end

  def block_bots
    render_view :index unless verify_recaptcha
  end

  def render_view(view)
    @contestants = Cache::Contestant.all.map { |c| ContestantPresenter.new c }
    render view
  end
end
