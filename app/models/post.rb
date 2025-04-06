class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  include Likeable
  include Shareable
  include Commentable

  def as_json(options = {})
      super(only: %i[ id body created_at likes_count shares_count comments_count ])
        .merge(liked_by_current_user: liked_by_current_user)
        .merge(user: user.as_json)
  end

  def liked_by_current_user
    Like.where(likeable: self, user: Current.user).exists?
  end
end
