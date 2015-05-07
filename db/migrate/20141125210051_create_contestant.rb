class CreateContestant < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.string :name
    end
  end
end
