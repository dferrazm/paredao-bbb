class Poll
  def start(deadline)
    Vote.destroy_all
    MyCache.init
    update_deadline deadline
  end

  def stop
    update_deadline Time.now
  end

  def deadline
    Time.parse($redis[:deadline]) if $redis[:deadline].present?
  end

  private

  def update_deadline(time)
    $redis[:deadline] = time.to_s
  end
end
