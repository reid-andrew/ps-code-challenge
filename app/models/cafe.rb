class Cafe < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :chairs, presence: true
end
