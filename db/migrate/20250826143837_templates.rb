class Templates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.string :name
      t.text :subject
      t.text :body
      t.timestamps
    end

  end
end
