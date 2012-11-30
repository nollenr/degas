# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(35)       not null
#  email           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved_user   :boolean          default(FALSE), not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save { |user| user.username = username.downcase}
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true, length: { maximum: 35 }, uniqueness: { case_sensitive: false }
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
