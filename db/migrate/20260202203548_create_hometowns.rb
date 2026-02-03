class CreateHometowns < ActiveRecord::Migration[7.2]
  def change
    create_table :hometowns do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :prefecture_code, null: false

      t.timestamps
    end
    add_index :hometowns, [ :user_id, :prefecture_code ], unique: true
  end
end
