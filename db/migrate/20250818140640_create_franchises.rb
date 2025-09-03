class CreateFranchises < ActiveRecord::Migration[8.0]
  def change
    create_table :franchises do |t|
      t.string :name
      t.text :location
      t.string :owner
      t.bigint :contact
      t.text  :description
      t.string :email ,  null: false, default: ""
      t.string :industry
      t.decimal :investment_level
      t.string :city
      t.integer :status , default: 1, null: false 
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end


