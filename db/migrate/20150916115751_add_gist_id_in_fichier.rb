class AddGistIdInFichier < ActiveRecord::Migration
  def change
    add_column :fichiers, :gist_id, :integer
  end
end
