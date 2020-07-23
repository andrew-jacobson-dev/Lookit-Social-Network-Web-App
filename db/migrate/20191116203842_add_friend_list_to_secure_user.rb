class AddFriendListToSecureUser < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_users, :friendlist, :integer, array: true, default: []
  end
end
