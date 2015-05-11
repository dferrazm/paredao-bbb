class VoteRecorderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :recorder

  def perform
    Cache::Votes.flush_all
  end
end
