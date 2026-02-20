class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :reacted_posts, through: :reactions, source: :post
  has_many :hometowns, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 30 }
  validate :avatar_validation

  def own?(object)
    id == object&.user_id
  end

  def reacted_to?(post, reaction_type)
    reactions.exists?(post_id: post.id, reaction_type: reaction_type.to_s)
  end

  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png image/webp].freeze

  validates :avatar,
    content_type: { in: ACCEPTED_CONTENT_TYPES },
    size: { less_than_or_equal_to: 5.megabytes }

  # 小さめ
  def avatar_index
    return unless avatar.attached?
    avatar.variant(resize_to_fill: [96, 96]).processed
  end

  # 大きめ
  def avatar_show
    return unless avatar.attached?
    avatar.variant(resize_to_fill: [240, 240]).processed
  end
end
