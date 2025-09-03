class CreateFranchiseDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :franchise_details do |t|
      t.string :investment
      t.string :breakeven
      t.string :area
      t.string :roi
      t.string :locations
      t.string :year
      t.text :about
      t.string :origin
      t.text :support
      t.text :available
      t.text :requirements
      t.text :who_we_look_for
      t.json :training
      t.references :franchise, null: false, foreign_key: true
      t.timestamps
    end
  end
end
