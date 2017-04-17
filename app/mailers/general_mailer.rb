class GeneralMailer < ActionMailer::Base
  default :from => 'nitro-noreply@northwestern.edu'

  def general_html_message(subject_line,recipient)
    mail({
      :content_type => "text/html",
      :subject      => subject_line,
      :to           => recipient
    })
  end


  def monthly_report_message(report)
    attachments["competitions_report_#{Date.today}.csv"] = File.read(report)
    mail({
      subject: "NITRO Competitions Monthly Report for #{Date.today}",
      to: 'matthew.baumann@northwestern.edu' })
  end
end
