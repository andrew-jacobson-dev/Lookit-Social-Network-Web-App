class AddFriendrequestsToSecureUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_users, :friendrequests, :integer, array: true, default: []
  end
end
