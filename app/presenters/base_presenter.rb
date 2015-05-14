class BasePresenter
  attr_reader :target, :v

  def initialize(target)
    @target = target
    @v = ActionController::Base.helpers # view helpers
  end
end
