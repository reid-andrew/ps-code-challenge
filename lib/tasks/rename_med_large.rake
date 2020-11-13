namespace :data do
  desc "Rename medium and large cafes"
  task :rename_med_large => :environment do
    Cafe.concatenate_med_large_cafes
  end
end
