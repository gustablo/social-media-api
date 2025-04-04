class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :body, null: false
      t.integer :likes_count, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
