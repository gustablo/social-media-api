class CreateLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.belongs_to :likeable, polymorphic: true

      t.timestamps
    end
  end
end
