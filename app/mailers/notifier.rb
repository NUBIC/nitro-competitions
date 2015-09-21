# encoding: UTF-8
class Notifier < ActionMailer::Base
  require "#{Rails.root}/app/helpers/application_helper"
  include ApplicationHelper
  require "#{Rails.root}/app/helpers/submissions_helper"
  include SubmissionsHelper

  ADMIN_EMAIL_LIST = NucatsAssist.admin_email_addresses

  def finalize_message(from, subject, submission, the_submission_url, the_project_url)
    set_mail_attibutes(from, subject, submission, the_submission_url, the_project_url)
    mail(from: from, to: @recipients, cc: @cc, bcc: @bcc, subject: subject)
  end

  def ord_message(from, subject, submission, the_submission_url, the_project_url)
    set_mail_attibutes(from, subject, submission, the_submission_url, the_project_url)
    mail(from: from, to: @recipients, cc: @cc, bcc: @bcc, subject: subject)
  end

  def set_mail_attibutes(from, subject, submission, the_submission_url, the_project_url)
    @from         = from
    headers       'Reply-to' => "#{from}"
    @recipients   = determine_recipients(submission)
    @cc           = determine_cc_recipients(submission)

    @bcc          = ADMIN_EMAIL_LIST
    @sent_on      = Time.now
    @content_type = 'text/html'

    # from the parameters
    @subject            = subject
    @the_submission_url = the_submission_url
    @the_project_url    = the_project_url

    # determined from the submission
    @name = submission.applicant.try(:first_name)
    @submission = submission
    @key_personnel = submission.key_personnel_names
    @status_notes = determine_status_notes(submission)
    @docs_array = list_submission_files_as_array(submission)
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
      result = [Rails.application.config.testing_to_address]
    end
    result = result - ADMIN_EMAIL_LIST
    result
  end

  def determine_status_notes(submission)
    return '' if submission.status_reason.blank?
    "<ul style='color:red;'><li>" + submission.status_reason.join('</li><li>') + '</li></ul>'
  end

  def reviewer_assignment(submission_review, submission)
    @submission_review = submission_review
    @reviewer          = submission_review.reviewer
    @submission        = submission
    @project           = @submission.project
    @program           = @project.program
    @sent_on           = Time.now
    @content_type      = 'text/html'

    from = Rails.application.config.from_address
    to   = @reviewer.email
    cc   = @program.admins.map(&:email)
    bcc  = ADMIN_EMAIL_LIST

    mail(from: from, to: to, cc: cc, bcc: bcc, subject: "#{NucatsAssist.plain_app_name} Reviewer Assignment")
  end

  def reviewer_opt_out(reviewer, submission)
    @reviewer          = reviewer
    @submission        = submission
    @project           = @submission.project
    @program           = @project.program
    @sent_on           = Time.now
    @content_type      = 'text/html'

    from = Rails.application.config.from_address
    to   = @program.admins.map(&:email)
    bcc  = ADMIN_EMAIL_LIST

    mail(from: from, to: to, bcc: bcc, subject: "#{NucatsAssist.plain_app_name} Reviewer Opt Out")
  end

end
