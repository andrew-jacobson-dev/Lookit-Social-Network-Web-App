class CreateSecureUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :secure_users do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    add_index :secure_users, :email, unique: true
  end
end
