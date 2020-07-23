class AddProfilepictureToSecureUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :secure_users, :profilepicture, :bytea
  end
end
