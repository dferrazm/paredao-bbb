require './config/boot'
require './config/environment'

module Clockwork
  every 1.second, 'Vote Recorder Worker job' do
    VoteRecorderWorker.perform_async
  end
end
