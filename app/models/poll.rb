class Poll
  include Singleton

  def self.current
    Poll.instance
  end

  def self.finished?
    Poll.current.finished?
  end

  def start(deadline)
    if update_deadline deadline
      Vote.destroy_all
      Cache::Base.init
      return true
    end

    false
  end

  def stop
    update_deadline Time.now
  end

  def deadline
    @deadline || load_deadline
  end

  def finished?
    deadline.nil? || deadline <= Time.now
  end

  private

  def update_deadline(time)
    begin
      @deadline = time.is_a?(Time) ? time : Time.parse(time)
    rescue => e
      return false
    end

    $redis[:deadline] = @deadline.to_s
    true
  end

  def load_deadline
    @deadline = Time.parse($redis[:deadline]) if $redis[:deadline].present?
  end
end
