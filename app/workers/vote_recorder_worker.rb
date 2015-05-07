class VoteRecorderWorker
  include Sidekiq::Worker
  sidekiq_options queue: :recorder

  def perform
    VoteRecorder.flush
  end
end