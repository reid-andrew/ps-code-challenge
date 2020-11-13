namespace :db do
  desc "Load data from csv file"
  task :reload => :environment do
    Rake::Task['db:migrate:reset'].invoke
    Rake::Task['data:load'].invoke
  end
end
