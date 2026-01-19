class Category < ApplicationRecord
  has_many :post, dependent: :restrict_with_error
end
