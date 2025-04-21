class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes
  has_one_attached :profile_picture
  has_one_attached :cover_picture

  has_many :following, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :nickname, uniqueness: true

  def as_json(options = {})
    super(only: %i[ id email_address nickname name bio ])
      .merge(following_count: following.count)
      .merge(followers_count: followers.count)
      .merge(is_following: is_following)
      .merge(cover_picture: cover_picture.present? ? Rails.application.routes.url_helpers.url_for(cover_picture) : nil)
      .merge(profile_picture: profile_picture.present? ? Rails.application.routes.url_helpers.url_for(profile_picture) : nil)
  end

  def is_following
    return false unless self.id
    return false unless Current&.user
    if Current.user.id != self.id
      return Follow
        .where(followed_id: self.id, follower_id: Current.user.id)
        .exists?
    end

    false
  end
end
