require 'csv'
require 'date'

#scp wakibbe@rails-prod2.nubic.northwestern.edu:/var/www/apps/nucats_assist/tmp/submissions2012-05-23.csv .
#scp wakibbe@rails-prod2.nubic.northwestern.edu:/var/www/apps/nucats_assist/tmp/projects_2012-05-23.csv .
#scp wakibbe@rails-prod2.nubic.northwestern.edu:/var/www/apps/nucats_assist/tmp/applicants2012-05-23.csv .
#scp wakibbe@rails-prod2.nubic.northwestern.edu:/var/www/apps/nucats_assist/tmp/key_personnel2012-05-23.csv .
#scp wakibbe@rails-prod2.nubic.northwestern.edu:/var/www/apps/nucats_assist/tmp/submission_reviews2012-05-23.csv .

namespace :reports do
  task :dixon => :environment do
    competitions = Project.where("lower(project_title) like '%dixon%'").all

    puts "#{competitions.length} competitions to process."

    competitions.each do |comp|
      puts comp.to_xml :include => {:submissions => {:include => [:applicant, :key_personnel, :key_people]}}
    end

  end


  # for Curie Chang, IRB approval
  task :curie => :environment do
    competitions = Project.includes(:program).where("lower(project_title) like '%dixon%'").all
    csv_export(competitions)
  end


  task :projects => :environment do
    competitions = Project.includes(:program).where("lower(project_title) like '%#{ENV['TITLE']}%'").all
    csv_export(competitions)
  end


  # for Keith Herzog and Pearl Go
  # This recreates much of task :projects, but with a few more fields for Keith and Pearl.
  task :herzog => :environment do
    competitions = Project.includes(:program).all
    generate_projects_with_submissions_csv(competitions)
  end

  task :nucats_projects => :environment do
    competitions = Program.find(12).projects
    csv_export(competitions)
  end

  task :vpor_projects => :environment do
    competitions = Program.find(4).projects
    csv_export(competitions)
  end

  # Runs the above tasks but with a passible argument for the sponsor
  # To run $rake reports:projects_by_sponsor[12]
  task :projects_by_sponsor, [:sponsor] => [:environment] do |t, args|
    args.with_defaults(:sponsor => 12)
    competitions = Program.find(args.sponsor.to_i).projects
    csv_export(competitions)
  end


  # New competitions (if any are added since our last data pull).
  # To run $rake reports:new_projects[2016,1,1]
  # http://stackoverflow.com/questions/825748/how-to-pass-command-line-arguments-to-a-rake-task
  task :new_projects, [:year, :month, :date] => [:environment] do |t, args|
    args.with_defaults(:year => Date.today.year, :month => Date.today.month - 1, :date => 1)
    test_date = Date.new(args.year.to_i, args.month.to_i, args.date.to_i)

    competitions = Project.includes(:program).where("created_at >= '%#{test_date}%'").all.order("created_at ASC")
    generate_projects_with_submissions_csv(competitions)
  end


  task :updated_projects, [:year, :month, :date] => [:environment] do |t, args|
    args.with_defaults(:year => Date.today.year, :month => Date.today.month - 1, :date => 1)
    test_date = Date.new(args.year.to_i, args.month.to_i, args.date.to_i)

    competitions = Project.includes(:program).where("updated_at >= '%#{test_date}%'").all.order("updated_at ASC")
    generate_projects_with_submissions_csv(competitions)
  end


  # task :monthly_report,[:year, :month, :date] => [:environment] do |t, args|

  #   args.with_defaults(:year => Date.today.year, :month => Date.today.month - 1, :date => 1)
  #   test_date = Date.new(args.year.to_i, args.month.to_i, args.date.to_i)

  #   new_competitions = Project.includes(:program).where("created_at >= '%#{test_date}%'")
  #   updated_competitions = Project.includes(:program).where("updated_at >= '%#{test_date}%'")
  #   competitions = (new_competitions + updated_competitions).uniq.sort_by(&:created_at)

  #   file_name = generate_projects_with_submissions_csv(competitions)
  #   puts "Creating monthly report file:"
  #   puts file_name.inspect
  #   GeneralMailer.monthly_report_message(file_name).deliver
  # end

  task :reviewer_list => :environment do
    reviewers = Reviewer.includes(:user).all
    file_name = generate_reviewers_csv(reviewers)
  end


  task :monthly_report => :environment do
    test_date = (Date.current - (1.month)).beginning_of_month
    new_competitions = Project.includes(:program).where("created_at >= '%#{test_date}%'")
    updated_competitions = Project.includes(:program).where("updated_at >= '%#{test_date}%'")

    file_name_new = generate_projects_with_submissions_csv(new_competitions, '_new')
    file_name_updated = generate_projects_with_submissions_csv(updated_competitions, '_updated')
    file_names = [file_name_new, file_name_updated]
    GeneralMailer.monthly_report_message(file_names).deliver
  end

  task :quarterly_report => :environment do
    competitions = Project.includes(:program).all
    file_name = generate_projects_with_submissions_csv(competitions)
    GeneralMailer.quarterly_report_message(file_name).deliver
  end

  task :role_emails, [:role] => :environment do |t, args|
    args.with_defaults(:role => 1)
    puts "Users with role: #{Role.find(args.role).name}."
    puts RolesUser.includes(:user).where(role_id: args.role.to_i).map { |ru| ru.user.email }.uniq.reject(&:blank?).sort
  end


  def csv_export(competitions)
    puts "#{competitions.length} competitions to process."
    generate_projects_csv(competitions)

    submissions = Submission.where("project_id in (:project_ids)", { :project_ids => competitions.map(&:id) }).all
    generate_submissions_csv(submissions)

    applicants = User.where("id in (:applicant_ids)", { :applicant_ids=> submissions.map(&:applicant_id) }).all
    generate_applicants_csv(applicants)

    key_personnel = KeyPerson.where("submission_id in (:submission_ids)", { :submission_ids=> submissions.map(&:id) }).all
    generate_key_personnel_csv(key_personnel)

    submission_reviews = SubmissionReview.where("submission_id in (:submission_ids)", { :submission_ids=> submissions.map(&:id) }).all
    generate_submission_reviews_csv(submission_reviews)

    puts "done"
  end


  # Here are the different CSV generators used above.
  def generate_projects_csv(competitions, extension = '')
    cols = ["program_id", "project_title", "project_description", "project_url", "initiation_date", "submission_open_date", "submission_close_date", "review_start_date", "review_end_date", "project_period_start_date", "project_period_end_date", "status"]
    file_name = "#{Rails.root}/tmp/projects_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}#{extension}.csv"
    puts "Writing projects file to " + file_name
    CSV.open(file_name, "w") do |csv|
      csv <<  ["project_id"] + cols + ["program_name",  "program.program_title",  "program.program_url",  "program.created_at",  "program.created_ip"]
      competitions.each do |competition|
        program = competition.program
        csv << [competition.id] + cols.map{|c| competition[c]} + [program.program_name, program.program_title, program.program_url, program.created_at, program.created_ip]
        STDOUT.flush
      end
     end
   end

  def generate_submissions_csv(submissions, extension = '')
    # cols = ["project_id", "applicant_id", "submission_title"]
    cols = ["id", "project_id", "applicant_id", "submission_title", "submission_status", "is_human_subjects_research", "is_irb_approved", "irb_study_num", "use_nucats_cru", "nucats_cru_contact_name", "use_stem_cells", "use_embryonic_stem_cells", "use_vertebrate_animals", "is_iacuc_approved", "iacuc_study_num", "direct_project_cost", "is_new", "use_nmh", "use_nmff", "use_va", "use_ric", "use_cmh", "not_new_explanation", "other_funding_sources", "is_conflict", "conflict_explanation", "effort_approver_ip", "submission_at", "completion_at", "effort_approver_username", "department_administrator_username", "effort_approval_at", "created_id", "created_ip", "updated_id", "updated_ip", "deleted_at", "deleted_id", "deleted_ip", "created_at", "updated_at", "submission_reviews_count", "application_document_id", "budget_document_id", "submission_category", "core_manager_username", "cost_sharing_amount", "cost_sharing_organization", "received_previous_support", "previous_support_description", "committee_review_approval", "abstract", "other_support_document_id", "document1_id", "document2_id", "document3_id", "document4_id", "applicant_biosketch_document_id", "notification_cnt", "notification_sent_at", "notification_sent_by_id", "notification_sent_to", "supplemental_document_id", "total_amount_requested", "amount_awarded", "type_of_equipment"]
    file_name = "#{Rails.root}/tmp/submissions#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}#{extension}.csv"
    puts "Writing submissions file to " + file_name
    CSV.open(file_name, "w") do |csv|
      csv <<  ["submission_id"] + cols
      submissions.each do |submission|
        csv << [submission.id] + cols.map{|c| submission[c]}
        STDOUT.flush
      end
    end
  end

  def generate_applicants_csv(applicants, extension = '')
    user_cols = ["username", "email", "era_commons_name", "first_name", "last_name", "middle_name", "name_suffix", "primary_department", "title", "degrees"]
    file_name = "#{Rails.root}/tmp/applicants_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}#{extension}.csv"
    puts "Writing applicants file to " + file_name
    CSV.open(file_name, "w") do |csv|
      csv <<  ["user_id"] + user_cols
      applicants.each do |applicant|
        csv << [applicant.id] + user_cols.map{|c| applicant[c]}
        STDOUT.flush
      end
    end
  end

  def generate_key_personnel_csv(key_personnel, extension = '')
    user_cols = ["username", "email", "era_commons_name", "first_name", "last_name", "middle_name", "name_suffix", "primary_department", "title", "degrees"]
    cols = ["submission_id", "user_id", "role"]
    file_name = "#{Rails.root}/tmp/key_personnel_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}#{extension}.csv"
    puts "Writing key_personnel file to " + file_name
    CSV.open(file_name, "w") do |csv|
      csv <<  cols+ user_cols
      key_personnel.each do |key_p|
        user = key_p.user
        csv << cols.map{|c| key_p[c]} + (user.nil? ? user_cols.map{|c| ''} : user_cols.map{|c| user[c]})
        STDOUT.flush
      end
    end
  end

  def generate_submission_reviews_csv(submission_reviews, extension = '')
    user_cols = ["username", "era_commons_name", "first_name", "last_name", "middle_name", "email", "degrees", "name_suffix"]
    cols = ["submission_id", "reviewer_id", "review_score", "review_text", "review_status", "review_completed_at", "created_at", "updated_at", "innovation_score", "impact_score", "scope_score", "team_score", "environment_score",
      "budget_score", "completion_score", "innovation_text", "impact_text", "scope_text", "team_text", "environment_text", "budget_text", "overall_score", "overall_text", "other_score", "other_text"]
    file_name = "#{Rails.root}/tmp/submission_reviews#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}#{extension}.csv"
    puts "Writing submission_reviews file to " + file_name
    CSV.open(file_name, "w") do |csv|
      csv <<  ["submission_review_id"] + cols + user_cols
      submission_reviews.each do |submission_review|
        reviewer = submission_review.reviewer
        csv << [submission_review.id] + cols.map{|c| submission_review[c]}  + user_cols.map{|c| reviewer[c]}
        STDOUT.flush
      end
    end
  end

  def generate_projects_with_submissions_csv(competitions, extension = '')
    cols = ["program_id", "project_title", "project_description", "project_url", "created_at", "updated_at", "initiation_date", "submission_open_date", "submission_close_date", "review_start_date", "review_end_date", "project_period_start_date", "project_period_end_date", "status"]
    file_name = "#{Rails.root}/tmp/projects_kh_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}#{extension}.csv"
    puts "Writing projects file to " + file_name
    CSV.open(file_name, "w") do |csv|
      csv <<  ["project_id"] + cols + ["program_name",  "program.program_title",  "program.program_url",  "program.created_at",  "program.created_ip", "submission_count", "assigned_submissions", "unassigned_submissions", "filled_submissions", "unfilled_submissions", "complete_submissions", "incomplete_submissions"]
      competitions.each do |competition|
        program = competition.program
        submission_count = competition.submissions.count
        assigned_submissions = competition.submissions.assigned_submissions.count
        unassigned_submissions = competition.submissions.unassigned_submissions.count
        filled_submissions = competition.submissions.filled_submissions.count
        unfilled_submissions = competition.submissions.unfilled_submissions.count
        complete_submissions = competition.complete_submissions.count
        incomplete_submissions = competition.incomplete_submissions.count
        csv << [competition.id] + cols.map{|c| competition[c]} + [program.program_name, program.program_title, program.program_url, program.created_at, program.created_ip, submission_count, assigned_submissions, unassigned_submissions, filled_submissions, unfilled_submissions, complete_submissions, incomplete_submissions]
        STDOUT.flush
      end
    end
    return file_name
  end

  def generate_reviewers_csv(reviewers, extension = '')
    cols = ["program_id", "user_id", "created_id", "created_ip", "updated_ip", "deleted_at", "deleted_id", "deleted_ip", "created_at", "updated_at"]
    file_name = "#{Rails.root}/tmp/reviewers_#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}#{extension}.csv"
    puts "Writing reviewers file to " + file_name
    CSV.open(file_name, "w") do |csv|
      csv <<  ["reviewer_id"] + cols + ["user.last_name",  "user.first_name",  "user.username",  "user.email"]
      reviewers.each do |reviewer|
        user = reviewer.user
        csv << [reviewer.id] + cols.map{|r| reviewer[r]} + [user.last_name, user.first_name, user.username, user.email]
        STDOUT.flush
      end
     end
   end

end
