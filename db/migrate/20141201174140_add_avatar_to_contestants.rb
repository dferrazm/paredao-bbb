class AddAvatarToContestants < ActiveRecord::Migration
  def change
    add_column :contestants, :avatar, :string
  end
end
