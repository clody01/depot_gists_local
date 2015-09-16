class AddDefalteValueToPublicInGist < ActiveRecord::Migration
  def change
    change_column :gists, :public, :boolean, :default => false
  end
end
