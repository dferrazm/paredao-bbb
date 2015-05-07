class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes, id: false do |t|
      t.integer :contestant_id
    end

    add_index :votes, :contestant_id
  end
end
