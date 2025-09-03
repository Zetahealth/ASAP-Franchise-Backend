class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.string :subject
      t.string :franchise_name # optional for your use case
      t.string :status, default: "Pending" # Pending, Open, Closed
      t.references :created_by, foreign_key: { to_table: :users }, null: true
      t.timestamps
    end
  end
end
