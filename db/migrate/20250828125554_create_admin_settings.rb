class CreateAdminSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_settings do |t|
      t.integer :role
      t.references :user, null: false, foreign_key: true
      t.json :permissions, null: false 
      t.timestamps
    end
  end
end
