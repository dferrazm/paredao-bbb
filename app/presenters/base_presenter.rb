class BasePresenter
  def initialize(target)
    @target = target
  end

  # View helpers
  def v
    ActionController::Base.helpers
  end
end
