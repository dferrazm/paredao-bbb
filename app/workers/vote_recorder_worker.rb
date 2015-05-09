class VoteRecorderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :recorder

  def perform
    Cache::Vote.flush_all
  end
end
