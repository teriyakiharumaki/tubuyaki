class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.text :body
      t.integer :likes_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
