class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :prefecture_code, null: false
      t.references :category, null: false, foreign_key: true
      t.text :body, null: false
      t.string :place_name
      t.string :google_place_id
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.timestamps
    end
    
    add_index :posts, :prefecture_code
  end
end
