# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# set :environment, ENV['RAILS_ENV']
set :output, {:error => 'log/cron_error.log', :standard => 'log/cron.log'}

case environment
  # whenever --update-crontab --set environment=development
  when 'development'
  #   every 2.minutes do
  #     rake "reports:monthly_report"
  #     puts "Running monthly report."
  #   end

  #   every 2.minutes do
  #     rake "db:backup"
  #     puts "Running backup."
  #   end
  #
  # when 'staging'
  #
  # whenever --update-crontab 
  when 'production'
    # every 1.month, :at => "start of the month at 1:00am" do
    #   rake "db:backup"
    #   puts "Running backup."
    # end
    every 1.month, :at => "start of the month at 5:00am" do
      rake "reports:monthly_report"
      puts "Running monthly report."
    end

    # Used cron syntax to create a quarterly report. This should run at 
    # 5:30 on the first of every March, June, September, and December
    every '30 5 1 3,6,9,12 *' do
      rake "reports:quarterly_report"
      puts "Running quarterly report."
    end
end