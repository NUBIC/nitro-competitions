# encoding: UTF-8
require 'config'

def send_finalize_email(submission, user)
  if allow_emails? || user.username == 'wakibbe'
    before_notify_email(submission)
    begin
      Notifier.finalize_message(Rails.application.config.from_address,
                                'Thank you for your NUCATS Assist Submission',
                                submission,
                                submission_url(submission.id),
                                project_url(submission.project.id)).deliver
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
      rescue
        puts msg
      end
    end
  else
    msg = 'Skipped thank you email'
    begin
      logger.error msg
    rescue
      puts msg
    end
  end
  true
end
