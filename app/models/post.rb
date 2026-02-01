class Post < ApplicationRecord
  include JpPrefecture

  belongs_to :user
  belongs_to :category

  has_many :reactions, dependent: :destroy
  has_many :reacting_users, through: :reactions, source: :user

  jp_prefecture :prefecture_code

  validates :body, presence: true, length: { maximum: 280 }
  validates :prefecture_code, presence: true
  validates :place_name, length: { maximum: 100 }, allow_blank: true

  # google_place関連
  validates :google_place_id, length: { maximum: 255 }, allow_blank: true
  validates :latitude, numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true

  def prefecture_name
    prefecture&.name
  end

  def reaction_count(reaction_type)
    reactions.count { |r| r.reaction_type == reaction_type.to_s }
  end
end
