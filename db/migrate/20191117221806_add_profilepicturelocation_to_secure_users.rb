class AddProfilepicturelocationToSecureUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_users, :profilepicturelocation, :string
  end
end
