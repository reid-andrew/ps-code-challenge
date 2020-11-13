namespace :db do
  desc "Reset database and load seeds from csv files"
  task :reload => :environment do
    Rake::Task['db:migrate:reset'].invoke
    data_load(Cafe, '/public/Street Cafes 2020-21.csv')
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.reset_pk_sequence!(table)
    end
  end

  def data_load(model, file)
    require 'csv'
    path = File.join Rails.root
    csv_text = File.read(File.join(path, file))
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash
      record = {name: row["Café/Restaurant Name"],
                address: row["Street Address"],
                post_code: row["Post Code"],
                chairs: row["Number of Chairs"]}
      model.create!(record)
    end
  end
end
