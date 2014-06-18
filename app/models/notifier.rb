# encoding: UTF-8
class Notifier < ActionMailer::Base
  require "#{Rails.root}/app/helpers/application_helper"
  include ApplicationHelper
  require "#{Rails.root}/app/helpers/submissions_helper"
  include SubmissionsHelper

  def finalize_message(from, subject, submission, the_submission_url, the_project_url)
    to = determine_recipients(submission)
    cc_list = determine_cc_recipients(submission)
    status_notes = determine_status_notes(submission)

    @recipients   = to
    @cc           = cc_list
    @bcc          = 'wakibbe@northwestern.edu'
    @from         = from
    headers         'Reply-to' => "#{from}"
    @subject      = subject
    @sent_on      = Time.now
    @content_type = 'text/html'

    @name = submission.applicant.try(:first_name)
    @submission = submission
    @key_personnel = submission.key_personnel_names
    @the_submission_url = the_submission_url
    @the_project_url = the_project_url
    @status_notes = status_notes
    @docs_array = list_submission_files_as_array(submission)
    mail(from: from, to: to, cc: cc_list, subject: subject)
  end

  def determine_recipients(submission)
    result = submission.applicant.email
    if submission.applicant != submission.submitter && !submission.submitter.blank?
      result = [submission.applicant.email, submission.submitter.email].join(', ')
    end
    result
  end

  def determine_cc_recipients(submission)
    if Rails.application.config.send_notification_to_all
      result = submission.key_personnel_emails || []
      result += submission.project.program.admins.map(&:email)
    else
      result = Rails.application.config.testing_to_address
    end
    result
  end

  def determine_status_notes(submission)
    return '' if submission.status_reason.blank?
    "<ul style='color:red;'><li>" + submission.status_reason.join('</li><li>') + '</li></ul>'
  end

end
