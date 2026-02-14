class AddHometownVisibilityTmpToUsers < ActiveRecord::Migration[7.2]
  class MigrationUser < ApplicationRecord
    self.table_name = :users
  end

  def up
    add_column :users, :hometown_visibility_tmp, :boolean, default: false, null: false

    MigrationUser.reset_column_information
    MigrationUser.find_each do |user|
      user.update_columns(hometown_visibility_tmp: (user[:hometown_visibility] == 1))
    end
  end

  def down
    remove_column :users, :hometown_visibility_tmp
  end
end
