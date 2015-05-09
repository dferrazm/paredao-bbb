class Cache::Contestant < Contestant
  def self.create(params)
    contestant = super params
    contestant.tap { |cont| MyCache.add(cont) if cont.persisted? }
  end

  def destroy
    super
    MyCache.remove self
  end
end
