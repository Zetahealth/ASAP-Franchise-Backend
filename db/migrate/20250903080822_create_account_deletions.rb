class CreateAccountDeletions < ActiveRecord::Migration[8.0]
  def change
    create_table :account_deletions do |t|
      t.integer :user_id
      t.string :user_email
      t.string :reason
      t.text :comments

      t.timestamps
    end
  end
end
