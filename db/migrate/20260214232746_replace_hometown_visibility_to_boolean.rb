class ReplaceHometownVisibilityToBoolean < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :hometown_visibility, :integer
    rename_column :users, :hometown_visibility_tmp, :hometown_visibility
  end
end
