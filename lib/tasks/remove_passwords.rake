namespace :db do
  task remove_passwords: :environment do
    Log.where("params like '%password%'").delete_all
  end
end