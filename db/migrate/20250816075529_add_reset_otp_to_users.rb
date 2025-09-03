class AddResetOtpToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :reset_password_otp, :string
    add_column :users, :reset_password_otp_sent_at, :datetime
    add_column :users, :role, :integer, default: 2, null: false 
    add_column :users, :franchise_id, :integer, null: true
  end
end
