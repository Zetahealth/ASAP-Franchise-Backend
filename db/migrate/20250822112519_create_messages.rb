class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      # For logged-in users
      t.references :sender, foreign_key: { to_table: :users }, null: true
      t.references :receiver, foreign_key: { to_table: :users }, null: true
      # t.references :messages, :conversation, foreign_key: true, null: true
      # For guest messages
      t.string :name
      t.string :email
      t.string :phone
      t.string :subject
      # Common fields
      t.text :content, null: false
      t.boolean :is_contact_query, default: false
      t.boolean :status
      t.timestamps
    end
  end
end
