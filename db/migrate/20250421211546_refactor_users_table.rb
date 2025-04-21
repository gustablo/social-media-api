class RefactorUsersTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :cover_picture
    remove_column :users, :profile_picture

    add_column :users, :name, :string
    add_column :users, :bio, :string
  end
end
