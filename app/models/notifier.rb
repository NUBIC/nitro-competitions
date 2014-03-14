# encoding: UTF-8
class Notifier < ActionMailer::Base
  require "#{Rails.root}/app/helpers/application_helper"
  include ApplicationHelper
  require "#{Rails.root}/app/helpers/submissions_helper"
  include SubmissionsHelper

  def finalize_message(from, subject, submission, the_submission_url, the_project_url)
    if submission.applicant != submission.submitter && !submission.submitter.blank?
      to = [submission.applicant.email, submission.submitter.email].join(', ')
    else
      to = submission.applicant.email
    end
    cc_list = submission.key_personnel_emails || []
    cc_list += submission.project.program.admins.map(&:email)
    name = submission.applicant.first_name

    if submission.status_reason.blank?
      status_notes = ''
    else
      status_notes = "<ul style='color:red;'><li>" + submission.status_reason.join('</li><li>') + '</li></ul>'
    end

    @recipients   = to
    @cc           = cc_list
    @bcc          = 'wakibbe@northwestern.edu'
    @from         = from
    headers         'Reply-to' => "#{from}"
    @subject      = subject
    @sent_on      = Time.now
    @content_type = 'text/html'

    @name = name
    @submission = submission
    @key_personnel = submission.key_personnel_names
    @the_submission_url = the_submission_url
    @the_project_url = the_project_url
    @status_notes = status_notes
    @docs_array = list_submission_files_as_array(submission)
    mail(from: from, to: to, cc: cc_list, subject: subject)
  end

end
