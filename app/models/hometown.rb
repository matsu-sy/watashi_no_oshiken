class Hometown < ApplicationRecord
  belongs_to :user

  validate :limit_three_per_user, on: :create

    private
  
  def limit_three_per_user
    return unless user
    if user.hometowns.count > = 3
      errors.add(:prefecture_code, "は最大3つまでしか登録できません")
    end
  end
end
