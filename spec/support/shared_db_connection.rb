class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end

# Monkey patch ActiveRecord to force all threads to share the same connection.
# This is needed to work with Capybara on Poltergeist because it starts the db connection in a new thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
