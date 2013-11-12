require 'config'

def send_finalize_email(submission, user)
  if allow_emails? or user.username == 'wakibbe'
    before_notify_email(submission)
    begin
      Notifier.deliver_finalize_message("nucatsassist@nubic.northwestern.edu", "Thank you for your NUCATS Assist Submission", submission, submission_url(submission.id), project_url(submission.project.id))
      submission.save!
      begin
        logger.error "Thank you email for #{submission.submission_title} was successfully sent"
      rescue
        puts "Thank you email for #{submission.submission_title} was successfully sent"
      end
      return true
    rescue Exception => err
      begin
        logger.error "Error occured. Unable to send thank you email. Error: #{err.message}"
      rescue
        puts "Error occured. Unable to send thank you email. Error: #{err.message}"
      end
    end
  else
    begin
      logger.error "Skipped thank you email"
    rescue
      puts "Skipped thank you email"
    end
  end
  return true
end
