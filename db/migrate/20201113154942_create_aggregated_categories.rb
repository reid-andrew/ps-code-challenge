class CreateAggregatedCategories < ActiveRecord::Migration[6.0]
  def change
    create_view :aggregated_categories
  end
end
