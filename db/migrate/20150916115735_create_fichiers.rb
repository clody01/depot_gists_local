class CreateFichiers < ActiveRecord::Migration
  def change
    create_table :fichiers do |t|
      t.string :filename
      t.text :content
      t.string :language

      t.timestamps null: false
    end
  end
end
