class DeviseCreateAdminUsers < ActiveRecord::Migration
  def change
    create_table(:admin_users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.timestamps
    end

    add_index :admin_users, :email,                unique: true
  end
end
