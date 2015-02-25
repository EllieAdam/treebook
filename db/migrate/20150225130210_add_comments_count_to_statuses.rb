class AddCommentsCountToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :comments_count, :integer, null: false, default: 0
  end
end
