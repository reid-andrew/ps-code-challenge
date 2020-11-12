class CreateCafes < ActiveRecord::Migration[6.0]
  def change
    create_table :cafes do |t|
      t.string :name
      t.string :address
      t.string :post_code
      t.integer :chairs
      t.timestamps
    end
  end
end
