class Notifier < ActionMailer::Base
  require "#{Rails.root}/app/helpers/application_helper"
  include ApplicationHelper
  require "#{Rails.root}/app/helpers/submissions_helper"
  include SubmissionsHelper
  
#  default :from => "wakibbe@northwestern.edu"
 
  def finalize_message(from, subject, submission, the_submission_url, the_project_url)
    if submission.applicant != submission.submitter
      to = [submission.applicant.email,submission.submitter.email].join(", ")
    else
      to = submission.applicant.email
    end
    cc_list = submission.key_personnel_emails || []
    name = submission.applicant.first_name

    if submission.status_reason.blank?
      status_notes = ''
    else
      status_notes = "<ul style='color:red;'><li>"+submission.status_reason.join("</li><li>")+ '</li></ul>'
    end      

#    recipients   to
#    from        from
#    cc          cc_list
#    headers         "Reply-to" => "#{from}"
#    subject      subject
#    sent_on      Time.now
#    content_type "text/html"
#    body :name=>name, :submission => submission, :key_personnel => submission.key_personnel_names, :submission_url => submission_url(submission.id), :project_url => project_url(submission.project.id), :status_notes=>status_notes 
    @recipients   = to
    @cc           = cc_list
    @bcc          = "wakibbe@northwestern.edu"
    @from         = from
    headers         "Reply-to" => "#{from}"
    @subject      = subject
    @sent_on      = Time.now
    @content_type = "text/html"
  
    body[:name]  = name
    body[:submission] = submission       
    body[:key_personnel] = submission.key_personnel_names       
    body[:the_submission_url] = the_submission_url
    body[:the_project_url] = the_project_url
    body[:status_notes] = status_notes
    body[:docs_array] = list_submission_files_as_array(submission)
  end


end
