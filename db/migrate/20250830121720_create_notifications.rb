class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :message
      t.datetime :scheduled_at
      t.boolean :enabled

      t.timestamps
    end
  end
end
