# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "[SEED] start"

category_names = [
  "場所",
  "風景",
  "人",
  "食べ物",
  "暮らし",
  "雰囲気",
  "意外なところ",
  "個人的推しポイント"
]

category_names.each do |name|
  Category.find_or_create_by!(name: name)
end

puts "[SEED] done count=#{Category.count}"
