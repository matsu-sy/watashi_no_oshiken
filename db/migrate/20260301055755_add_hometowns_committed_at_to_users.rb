class AddHometownsCommittedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :hometowns_committed_at, :datetime
  end
end
