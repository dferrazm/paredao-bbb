class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :contestant_id
    end

    add_index :votes, :contestant_id
  end
end
