class Post < ApplicationRecord
  include JpPrefecture

  belongs_to :user
  belongs_to :category

  jp_prefecture :prefecture_code

  def prefecture_name
    prefecture&.name
  end
end
