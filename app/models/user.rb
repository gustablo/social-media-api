class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts
  has_many :comments, dependent: :destroy

  has_many :following, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
