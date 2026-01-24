class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :hometown_visibility, { hidden: 0, visible: 1 }

  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
end
