class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable
  include Likeable

  def as_json(options = {})
    super(only: %i[ id created_at content likes_count ])
      .merge(user: user)
  end
end
