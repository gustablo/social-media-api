class AddProfilePictureToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :profile_picture, :string, null: true
    add_column :users, :cover_picture, :string, null: true
  end
end
