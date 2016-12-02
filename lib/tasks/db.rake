
# http://www.postgresql.org/docs/8.3/static/app-pgdump.html
# Most of the setup, backup, and restore come from enotis.
require 'erb'
require 'yaml'
require 'highline/import'

namespace :db do
  task :pg_setup => :environment do
    ar_config      = HashWithIndifferentAccess.new(ActiveRecord::Base.connection.instance_variable_get("@config"))
    fail 'This only works for postgres' unless ar_config[:adapter] == "postgresql"
   
    @app_name      = 'nucats_assist'
    @password      = ar_config[:password]
    @pg_options    = "-U #{ar_config[:username]} -h #{ar_config[:host] || 'localhost'} -p #{ar_config[:port] || 5432} #{ar_config[:database]}"
    @backup_folder = %w(production staging).include?(Rails.env) ? "/var/www/apps/#{@app_name}/shared/db_backups" : File.join(Rails.root,"tmp","db_backups")

    Dir.mkdir(@backup_folder) unless File.directory?(@backup_folder)
  end

  # The environment will need to be declared to run the backup.
  # e.g. RAILS_ENV=staging bundle exec rake db:backup
  desc "backup database"
  task :backup => :pg_setup do
    destination    = File.join(@backup_folder, "#{@app_name}_#{Rails.env}-#{Time.now.strftime("%Y-%m-%d_%H-%M-%S")}.sql.gz")
    puts "executing `pg_dump -O -o -c -x #{@pg_options} | gzip -f --best > #{destination}`"
    pgpassword_wrapper(@password){ `pg_dump -O -o -c -x #{@pg_options} | gzip -f --best > #{destination}` }
  end

  # the user associated with the DB needs to be a super user in order for the restore to work. 
  desc "restore database"
  task :restore => :pg_setup do |t|
    backup_files = Dir.glob(File.join(@backup_folder,"*.sql.gz")).sort
    fail "no backup files (*.sql.gz) found in #{@backup_folder}" if backup_files.empty?
    backup_files.each_with_index{|f,i| puts "#{i+1}:#{File.basename(f)}"}
    selected_index = ask("Which file? ", Integer){|q| q.above = 0; q.below = backup_files.size+1}
    pgpassword_wrapper(@password){`cat #{backup_files[selected_index.to_i-1]} | gunzip | psql #{@pg_options}`}
  end

  # http://stackoverflow.com/questions/23226900/rake-dbreset-drop-all-tables-but-not-database
  # http://stackoverflow.com/questions/16928668/rails-create-a-drop-table-cascade-migration
  desc "Erase all tables"
  task :clear => :environment do
    conn = ActiveRecord::Base.connection
    tables = conn.tables
    tables.each do |table|
      puts "Deleting #{table}"
      conn.drop_table(table, force: :cascade)
    end
  end

  private
  def pgpassword_wrapper(password)
    # Unlike mysqldump, you don't enter in the password on the command line, you set an environment variable
    raise 'You need to pass in a block' unless block_given?
    begin
      ENV['PGPASSWORD'] = password
      yield
    ensure
      ENV['PGPASSWORD'] = nil
    end
  end

end
