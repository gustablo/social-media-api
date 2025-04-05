class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  include Likeable
  include Shareable
  include Commentable
end
