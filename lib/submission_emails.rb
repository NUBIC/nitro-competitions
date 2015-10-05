# encoding: UTF-8
require 'config'

def send_finalize_email(submission, user)
  begin
    message = create_message(submission)
    logger.error("~~~ about to deliver message #{message.inspect}")
    message.deliver
    submission.save!
    msg = "Thank you email for #{submission.submission_title} was successfully sent"
    begin
      logger.error msg
    rescue
      puts msg
    end
    return true
  rescue Exception => err
    msg = "Error occured. Unable to send thank you email. Error: #{err.message}"
    begin
      logger.error msg
      ExceptionNotifier.notify_exception(err)
    rescue
      puts msg
    end
  end
  true
end

def create_message(submission)
  from = determine_from_address(submission)
  subject = "Thank you for your #{NucatsAssist.plain_app_name} Submission"

  path = "#{Rails.root}/app/views/notifier/#{sponsor_name(submission)}_message.html.erb"
  if File.exists?(path)
    msg_method = "#{sponsor_name(submission)}_message".to_sym
    subject = 'Thank you for your submission'
  else
    msg_method = :finalize_message
  end
  Notifier.send(msg_method,
                from,
                subject,
                submission,
                submission_url(submission.id),
                project_url(submission.project.id))
end

def sponsor_name(submission)
  submission.program_name.to_s.downcase
end

def determine_from_address(submission)
  email_addresses = { 'ord' => 'ord-nu@northwestern.edu' }
  result = Rails.application.config.from_address

  program_email_address = email_addresses[sponsor_name(submission)]
  result = program_email_address unless program_email_address.blank?
  result
end
