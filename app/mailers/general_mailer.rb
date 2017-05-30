class GeneralMailer < ActionMailer::Base
  default :from => 'nitro-noreply@northwestern.edu'

  def general_html_message(subject_line,recipient)
    mail({
      :content_type => "text/html",
      :subject      => subject_line,
      :to           => recipient
    })
  end


  def monthly_report_message(reports)
    reports.each_with_index do |report, index|
      attachments["competitions_report_#{Date.today}_#{index + 1}.csv"] = File.read(report)
    end

    mail({
      subject: "NITRO Competitions Monthly Report for #{Date.today}",
      to: Rails.configuration.nucats_assist_config[:reports][:recipients] })
  end
end
