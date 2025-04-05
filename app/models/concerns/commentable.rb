module Commentable
  extend ActiveSupport::Concern

  def add_comment(user, content)
    comment = comments.new(user: user, content: content)

    if comment.save
      self.comments_count = comments_count + 1
      save!
    end

    comment
  end
end
