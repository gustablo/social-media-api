module Shareable
  extend ActiveSupport::Concern

  def share(post_params)
    new_shareable = Post.new
    puts "DSLKAJDLASKJDLSKA"
    puts post_params
    new_shareable.body = post_params[:body]
    new_shareable.user_id = post_params[:user_id]
    new_shareable.parent_post_id = self.id

    if new_shareable.save
      self.shares_count = shares_count + 1
      save
    end
  end
end
