class GeneralMailer < ActionMailer::Base
  default :from => 'nitro-noreply@northwestern.edu'

  def general_html_message(subject_line,recipient)
    mail({
      :content_type => "text/html",
      :subject      => subject_line,
      :to           => recipient
    })
  end
end
