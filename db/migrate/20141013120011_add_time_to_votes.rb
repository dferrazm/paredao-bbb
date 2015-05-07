class AddTimeToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :time, :string
    add_index :votes, :time
  end
end
