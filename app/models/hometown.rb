class Hometown < ApplicationRecord
  include JpPrefecture
  jp_prefecture :prefecture_code
  
  belongs_to :user

  validates :prefecture_code, presence: true
  validates :prefecture_code, uniqueness: { scope: :user_id }

  validate :limit_three_per_user, on: :create

    private

  def limit_three_per_user
    return unless user
    if user.hometowns.count >= 3
      errors.add(:prefecture_code, :limit_three)
    end
  end
end
