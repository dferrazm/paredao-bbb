class VoteRecorderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :recorder

  def perform
    VoteStore.flush_all
  end
end
