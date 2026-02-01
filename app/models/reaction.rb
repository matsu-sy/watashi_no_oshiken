class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum reaction_type: { unknown: 0, like: 1, wantgo: 2 }

  validates :reaction_type, presence: true
  validates :user_id, uniqueness: { scope: [ :post_id, :reaction_type ] }
end
