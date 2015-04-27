class User < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :elo_changes

  has_secure_password

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, length: { minimum: 6 }


end
