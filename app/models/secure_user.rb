class SecureUser < ApplicationRecord
  has_secure_password

  # Validation for the SecureUser model
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, message: "A valid email address is required"}
  validates :username, presence: true, uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true

  # function: self.search(param)
  # purpose: This searches the SecureUser data model for the 'Find Friends' section. It returns users
  # whose first name, last name, or user name matches the search string.
  def self.search(search)
    # Search secure_users for first name or last name
    SecureUser.where('lower(firstname) ILIKE lower(?)', "#{search}%").or(SecureUser.where('lower(lastname) ILIKE lower(?)', "#{search}%")).or(SecureUser.where('lower(username) ILIKE lower(?)', "#{search}%"))
  end
end
