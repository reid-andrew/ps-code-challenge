class Cafe < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :chairs, presence: true

  before_create :set_category

  private

  def set_category
    category = case post_code[0..2]
    when "LS1"
      set_ls1_code
    when "LS2"
      set_ls2_code
    else
      'other'
    end
    self.category = category
  end

  def set_ls1_code
    case chairs
    when 0..10
      'ls1 small'
    when 11..100
      'ls1 medium'
    else
      'ls1 large'
    end
  end
end
