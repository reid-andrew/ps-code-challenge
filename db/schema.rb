# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_13_204540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cafes", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "post_code"
    t.integer "chairs"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "category"
  end


  create_view "aggregated_categories", sql_definition: <<-SQL
      SELECT c.category,
      count(c.id) AS total_places,
      sum(c.chairs) AS total_chairs
     FROM cafes c
    GROUP BY c.category
    ORDER BY c.category;
  SQL
  create_view "post_code_reports", sql_definition: <<-SQL
      SELECT c.post_code,
      count(c.id) AS total_places,
      sum(c.chairs) AS total_chairs,
      round(((((sum(c.chairs))::double precision / (( SELECT sum(c2.chairs) AS sum
             FROM cafes c2))::double precision) * (100)::double precision))::numeric, 2) AS pct_chairs,
      max((c5.name)::text) AS place_with_max_chairs,
      max(c5.chairs) AS max_chairs
     FROM (cafes c
       LEFT JOIN ( SELECT c3.name,
              c3.post_code,
              c3.chairs
             FROM cafes c3
            WHERE (((c3.post_code)::text, c3.chairs) IN ( SELECT c4.post_code,
                      max(c4.chairs) AS max
                     FROM cafes c4
                    GROUP BY c4.post_code))) c5 ON (((c.post_code)::text = (c5.post_code)::text)))
    GROUP BY c.post_code
    ORDER BY c.post_code;
  SQL
end
