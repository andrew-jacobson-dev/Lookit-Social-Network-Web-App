class RemoveFriendlistFromSecureUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :secure_users, :friendlist, :integer
  end
end
