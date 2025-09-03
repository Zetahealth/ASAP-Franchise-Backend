class CreateFranchiseReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :franchise_reviews do |t|
      t.string :user_name
      t.integer :rating
      t.text :comment
      t.date :date
      t.string :status
      t.references :franchise, null: false, foreign_key: true
      t.timestamps
    end
  end
end
