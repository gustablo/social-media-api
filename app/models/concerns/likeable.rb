module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy
  end

  def add_like(user)
    likes.create!(user: user)
    self.likes_count = likes_count + 1
    save!
  end

  def remove_like(user)
    like = Like.find_by(likeable: self, user: user)
    return unless like
    like.destroy!
    self.likes_count = likes_count - 1
    save!
  end
end
