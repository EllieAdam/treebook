class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.references :user, index: true
      t.references :status, index: true

      t.timestamps null: false
    end
  end
end
