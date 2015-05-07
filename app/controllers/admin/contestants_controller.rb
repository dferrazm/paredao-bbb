class Admin::ContestantsController < Admin::ApplicationController
  before_action :set_contestant, only: :destroy

  def index
    @contestants = Contestant.all
  end

  def new
    @contestant = Contestant.new
  end

  def create
    @contestant = ContestantRecorder.create contestant_params

    if @contestant.persisted?
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def destroy
    ContestantRecorder.destroy @contestant
    redirect_to action: 'index'
  end

  private

  def set_contestant
    @contestant = Contestant.find(params[:id])
  end

  def contestant_params
    params.require(:contestant).permit :name, :avatar
  end
end
