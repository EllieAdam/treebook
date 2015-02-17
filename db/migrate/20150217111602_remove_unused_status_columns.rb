class RemoveUnusedStatusColumns < ActiveRecord::Migration
  def change
    remove_column :statuses, :cached_votes_total
    remove_column :statuses, :cached_votes_score
    remove_column :statuses, :cached_weighted_score
    remove_column :statuses, :cached_weighted_total
    remove_column :statuses, :cached_weighted_average
    add_index :statuses, :created_at
  end
end
