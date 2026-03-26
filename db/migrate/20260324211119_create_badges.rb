class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.integer :badge_type, null: false

      t.timestamps
    end

    add_index :badges, [ :user_id, :post_id, :badge_type ], unique: true, name: 'index_badges_on_user_post_type'
  end
end
