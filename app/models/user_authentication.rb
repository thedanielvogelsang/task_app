class UserAuthentication < ApplicationRecord
  belongs_to :user

  has_secure_password

  def increment_login
    self.login_count += 1
  end
end
