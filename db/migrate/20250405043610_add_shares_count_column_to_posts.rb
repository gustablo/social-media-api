class AddSharesCountColumnToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :shares_count, :integer, default: 0
  end
end
