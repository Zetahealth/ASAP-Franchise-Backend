class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :file_type
      t.string :file_key
      t.string :file_url
      t.string :uploaded_by
      t.datetime :uploaded_at
      t.timestamps
    end
  end
end
