class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :file_key
      t.references :franchise, null: false, foreign_key: true
      t.timestamps
    end
  end
end
