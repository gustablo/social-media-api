class Post < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  has_many :comments, dependent: :destroy
  belongs_to :parent_post, class_name: "Post"
  has_many :childrens, class_name: "Post", foreign_key: "parent_post_id"
  include Likeable
  include Shareable
  include Commentable

  validate :images_count_within_limit

  def as_json(options = {})
    super(only: %i[ id body created_at likes_count shares_count comments_count ])
      .merge(user: user.as_json)
      .merge(liked_by_current_user: liked_by_current_user)
      .merge(images: images_urls)
      .merge(parent_post: parent_post)
  end

  def liked_by_current_user
    Like.where(likeable: self, user: Current.user).exists?
  end

  def images_count_within_limit
    if images.attachments.size > 4
      errors.add(:images, "max of 4 images")
    end
  end

  def images_urls
    images.map { |img| Rails.application.routes.url_helpers.url_for(img) }
  end
end
