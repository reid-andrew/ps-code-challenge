namespace :data do
  desc "Export and delete small cafes"
  task :export_small => :environment do
    export
    Cafe.delete_small_cafes
  end

  def export
    require 'csv'
    path = "#{Rails.root}/public/small_cafes_#{Time.now.utc}.csv"
    cafes = Cafe.where("cafes.category LIKE '%small'")
    headers = ["Name", "Address", "Post_Code", "Chairs", "Category", "Created", "Updated"]

    CSV.open(path, 'w', write_headers: true, headers: headers) do |writer|
      cafes.each do |cafe|
        writer << [ cafe.name,
                    cafe.address,
                    cafe.post_code,
                    cafe.chairs,
                    cafe.category,
                    cafe.created_at,
                    cafe.updated_at ]
      end
    end
  end
end
