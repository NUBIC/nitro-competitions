class GeneralMailer < ActionMailer::Base
  default :from => "competitions@northwestern.edu"

  def general_message(subject,text,recipient)
    @text = text
    mail(:to=>recipient,:subject=>subject)
  end
end
