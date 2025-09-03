class CreateAdminSettingsUserRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_settings_user_roles do |t|
      t.string :name
      t.integer :role
      t.json :permissions, null: false 
      t.timestamps
    end
  end
end
