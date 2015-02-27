class RemoveIndexFromCreatedAtInStatuses < ActiveRecord::Migration
  def change
    remove_index :statuses, column: :created_at
  end
end
