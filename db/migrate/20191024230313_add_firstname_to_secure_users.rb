class AddFirstnameToSecureUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_users, :firstname, :string
  end
end
