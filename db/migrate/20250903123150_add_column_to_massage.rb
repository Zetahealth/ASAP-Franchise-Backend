class AddColumnToMassage < ActiveRecord::Migration[8.0]
  def change
    add_reference :messages, :conversation, foreign_key: true, null: true
  end
end
