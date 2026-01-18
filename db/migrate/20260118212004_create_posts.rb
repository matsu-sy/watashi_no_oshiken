class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :prefecture_code
      t.references :category, null: false, foreign_key: true
      t.text :body
      t.string :place_name
      t.string :google_place_id
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
