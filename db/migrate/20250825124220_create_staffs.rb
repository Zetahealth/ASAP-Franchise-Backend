class CreateStaffs < ActiveRecord::Migration[8.0]
  def change
    create_table :staffs do |t|
      t.references :franchise, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.json :permissions, null: false 
      t.timestamps
    end
  end
end
