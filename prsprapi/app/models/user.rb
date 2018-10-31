class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :contacts, :foreign_key => 'owner_id'
  has_many :groups, :foreign_key => 'owner_id'

  def display_name
    return self.id.to_s + '-' + self.email
  end

  def self.valid_password?(email, password)
    user = where(email: email).first
    [user&.valid_password?(password), user]
  end

  def generate_auth_token
    token = SecureRandom.hex
    self.update_columns(authentication_token: token)
    token
  end

  def invalidate_auth_token
    self.update_columns(authentication_token: nil)
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.where(auth_token: token).where("token_created_at >= ?", 1.month.ago).first
    end
  end
  
end
