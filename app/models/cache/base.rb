require 'contestant'

class Cache::Base
  def self.init
    $redis = Redis.new host: 'localhost', port: 6379
    begin
      $redis[:contestants] = Contestant.ids.join ','
      Contestant.all.each do |cont|
        $redis["name_#{cont.id}"] = cont.name
        $redis["votes_#{cont.id}"] = cont.votes.count
      end
    rescue => e
      puts "Error when initing redits keys. Your DB may not be migrated yet: #{e.message}"
      $redis[:contestants] = ''
    end
  end
end
