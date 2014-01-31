class AuditsController < ApplicationController

  caches_action(:user_data, :application_data, :applicant_data, :submission_data, :key_personnel_data, :reviewer_data, :review_data, :login_data, :activity_data, :program_data)

  require 'csv_generator'
  include AdminsHelper

  def index
    @title = "Graph of activities"
    @data_url = activity_data_audits_url
    @list_arrays = ["logins","users","applications","applicants","key_personnel","reviewers","reviews"]
    render_view_activities
  end

  def sponsor
    @program = current_program
    @data_url = program_data_audit_url(@program)
    @title = "Graph of activities for sponsor #{@program.program_name}"
    @list_arrays = ["logins","users","applications","applicants","key_personnel","reviewers","reviews"]
    render_view_activities
  end

  # personnel_data, applicant_data, submission_data, key_personnel_data all have csv feeds to the amCharts graph

  def activity_data
    logins = Log.logins
    users = User.all.compact.uniq
    applications = Submission.all
    applicants = Submission.all.collect{ |s| s.applicant }.compact.uniq
    key_personnel = Submission.all.collect{ |s| s.key_personnel.collect{ |k| k } }.flatten.compact.uniq
    reviewers = Reviewer.all.compact.uniq
    reviews = SubmissionReview.where('overall_score > 0').all
    data = generate_csv_from_array([logins, users, applications, applicants, key_personnel, reviewers, reviews])
    # logger.error data.inspect
    # data is an array. why?
    render :template => "shared/csv_data_array", :locals => {:data => data}, :layout => false
  end

  def program_data
    @program = Program.find(params[:id])
    logins = @program.logs.logins
    applications = @program.projects.map{ |p| p.submissions }.flatten
    applicants = applications.map{ |s| s.applicant }.flatten.uniq
    key_personnel = applications.collect{|s| s.key_personnel.collect{ |k| k } }.flatten.compact.uniq
    reviewers = @program.reviewers
    reviews = applications.map{ |a| a.submission_reviews..where('overall_score > 0').all }.flatten
    submitters = applications.map{ |s| s.submitter }.compact.uniq
    users = applicants + key_personnel + reviewers + submitters
    data = generate_csv_from_array([logins, users, applications, applicants, key_personnel, reviewers, reviews])
    # logger.error data.inspect
    # data is an array. why?
    render :template => "shared/csv_data_array", :locals => {:data => data}, :layout => false
  end

  def user_data
    users = User.all.compact.uniq
    data = generate_csv(users)
    render :template => "shared/csv_data", :locals => {:data => data}, :layout => false
  end

  def application_data
    applications = Submission.all
    data = generate_csv(applications)
    render :template => "shared/csv_data", :locals => {:data => data}, :layout => false
  end

  def applicant_data
    applicants = Submission.all.collect{ |s| s.applicant }.compact.uniq
    data = generate_csv(applicants)
    render :template => "shared/csv_data", :locals => {:data => data}, :layout => false
  end

  def key_personnel_data
    key_personnel = Submission.all.collect{ |s| s.key_personnel.collect{ |k| k } }.flatten.compact.uniq
    data = generate_csv(key_personnel)
    render :template => "shared/csv_data", :locals => {:data => data}, :layout => false
  end

  def reviewer_data
    reviewers = Reviewer.all.compact.uniq
    data = generate_csv(reviewers)
    render :template => "shared/csv_data", :locals => {:data => data}, :layout => false
  end

  def review_data
    reviews = SubmissionReview.where('overall_score > 0').all
    data = generate_csv(reviews, true)
    render :template => "shared/csv_data", :locals => {:data => data}, :layout => false
  end

  def login_data
    logs = Log.logins
    data = generate_csv(logs, true)
    render :template => "shared/csv_data", :locals => {:data => data}, :layout => false
  end

end
