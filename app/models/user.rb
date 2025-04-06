class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes

  has_many :following, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :nickname, uniqueness: true

  def as_json(options = {})
    super(only: %i[ id email_address nickname ])
  end
end
