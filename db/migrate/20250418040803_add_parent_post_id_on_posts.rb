class AddParentPostIdOnPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :parent_post, null: true, index: true, foreign_key: { to_table: :posts }
  end
end
