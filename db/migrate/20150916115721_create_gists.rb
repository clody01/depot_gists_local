class CreateGists < ActiveRecord::Migration
  def change
    create_table :gists do |t|
      t.string :hubid
      t.string :description
      t.boolean :public
      t.string :userlogin
      t.boolean :saved

      t.timestamps null: false
    end
  end
end
