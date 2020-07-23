class AddLastnameToSecureUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_users, :lastname, :string
  end
end
