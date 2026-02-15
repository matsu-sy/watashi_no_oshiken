class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :reacted_posts, through: :reactions, source: :post
  has_many :hometowns, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }

  def own?(object)
    id == object&.user_id
  end

  def reacted_to?(post, reaction_type)
    reactions.exists?(post_id: post.id, reaction_type: reaction_type.to_s)
  end
end
