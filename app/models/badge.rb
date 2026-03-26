class Badge < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum :badge_type, { star: 0 }

  validates :badge_type, presence: true
  validates :post_id, uniqueness: { scope: [ :user_id, :badge_type ] }
end
