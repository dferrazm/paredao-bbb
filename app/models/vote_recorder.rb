class VoteRecorder
  def initialize(contestant)
    @contestant = contestant
  end

  def self.finish
    ENV['FINISH']
  end
end
