class Cafe < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true
  validates :chairs, presence: true

  before_save :set_category

  private

  class << self
    def delete_small_cafes
      small_cafes = Cafe.where("cafes.category LIKE '%small'")
      small_cafes.each(&:delete)
    end

    def concatenate_med_large_cafes
      med_large_cafes = Cafe.where("cafes.category LIKE '%medium' OR cafes.category LIKE '%large'")
      med_large_cafes.each do |cafe|
        cafe.name = "#{cafe.category}-#{cafe.name}"
        cafe.save
      end
    end
  end

  def set_category
    category =
      case post_code[0..2]
      when 'LS1'
        set_ls1_category
      when 'LS2'
        set_ls2_category
      else
        'other'
      end
    self.category = category
  end

  def set_ls1_category
    case chairs
    when 0..10
      'ls1 small'
    when 11..100
      'ls1 medium'
    else
      'ls1 large'
    end
  end

  def set_ls2_category
    cafes = Cafe.where("cafes.post_code LIKE 'LS2%'").map(&:chairs).sort
    count = cafes.count
    return 'ls2 large' if count <= 1

    median = find_median(cafes, count)
    chairs < median ? 'ls2 small' : 'ls2 large'
  end

  def find_median(cafes, count)
    if (count % 2).zero?
      first_half = (cafes[0...(count / 2)])
      second_half = (cafes[(count / 2)..-1])
      (first_half[-1] + second_half[0]) / 2.to_f
    else
      cafes[(count / 2).floor]
    end
  end
end
