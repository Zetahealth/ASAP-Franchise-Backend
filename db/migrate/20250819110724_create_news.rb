class CreateNews < ActiveRecord::Migration[8.0]
  def change
    create_table :news do |t|

      t.string :title
      t.string  :date
      t.string  :image
      t.json :paragraphs
      t.json  :listItems
      t.timestamps
    end
  end
end
