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
  # when 'development'
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
    every :sunday, :at => '2:00am' do # Use any day of the week or :weekend, :weekday
      rake "db:backup"
      puts "Running backup."
    end
    every 1.month, :at => "start of the month at 2:00am" do
      rake "reports:monthly_report"
      puts "Running monthly report."
    end
end