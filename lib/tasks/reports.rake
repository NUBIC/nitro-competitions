require 'fastercsv'

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

  task :curie => :environment do
    # for Curie Chang, IRB approval
    competitions = Project.includes(:program).where("lower(project_title) like '%dixon%'").all

    puts "#{competitions.length} competitions to process."

    cols = ["program_id", "project_title", "project_description", "project_url", "initiation_date", "submission_open_date", "submission_close_date", "review_start_date", "review_end_date", "project_period_start_date", "project_period_end_date", "status"]
    file_name = Rails.root + "/tmp/projects_#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing projects file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv <<  ["project_id"] + cols + ["program_name",  "program.program_title",  "program.program_url",  "program.created_at",  "program.created_ip"]
      competitions.each do |competition|
        program = competition.program
        csv << [competition.id] + cols.map{|c| competition[c]} + [program.program_name, program.program_title, program.program_url, program.created_at, program.created_ip]
        STDOUT.flush
      end
     end

    submissions = Submission.where("project_id in (:project_ids)", { :project_ids => competitions.map(&:id) }).all

    cols = ["project_id", "applicant_id", "submission_title"]
    file_name = Rails.root + "/tmp/submissions#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing submissions file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv <<  ["submission_id"] + cols
      submissions.each do |submission|
        csv << [submission.id] + cols.map{|c| submission[c]}
        STDOUT.flush
      end
    end

    applicants = User.where("id in (:applicant_ids)", { :applicant_ids=> submissions.map(&:applicant_id) }).all

    user_cols = ["username", "era_commons_name", "first_name", "last_name", "middle_name", "email", "degrees", "name_suffix"]

    file_name = Rails.root + "/tmp/applicants#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing applicants file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv <<  ["user_id"] + user_cols
      applicants.each do |applicant|
        csv << [applicant.id] + user_cols.map{|c| applicant[c]}
        STDOUT.flush
      end
    end

    key_personnel = KeyPerson.where("submission_id in (:submission_ids)", { :submission_ids=> submissions.map(&:id) }).all

    cols = ["submission_id", "user_id", "role"]
    file_name = Rails.root + "/tmp/key_personnel#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing key_personnel file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv <<  cols+ user_cols
      key_personnel.each do |key_p|
        user = key_p.user
        csv << cols.map{|c| key_p[c]} + (user.nil? ? user_cols.map{|c| ''} : user_cols.map{|c| user[c]})
        STDOUT.flush
      end
    end

    submission_reviews = SubmissionReview.where("submission_id in (:submission_ids)", { :submission_ids=> submissions.map(&:id) }).all

    cols = ["submission_id", "reviewer_id", "review_score", "review_text", "review_status", "review_completed_at", "created_at", "updated_at", "innovation_score", "impact_score", "scope_score", "team_score", "environment_score",
      "budget_score", "completion_score", "innovation_text", "impact_text", "scope_text", "team_text", "environment_text", "budget_text", "overall_score", "overall_text", "other_score", "other_text"]
    file_name = Rails.root + "/tmp/submission_reviews#{Time.now.strftime("%Y-%m-%d")}.csv"
    puts "Writing submission_reviews file to " + file_name
    FasterCSV.open(file_name, "w") do |csv|
      csv <<  ["submission_review_id"] + cols + user_cols
      submission_reviews.each do |submission_review|
        reviewer = submission_review.reviewer
        csv << [submission_review.id] + cols.map{|c| submission_review[c]}  + user_cols.map{|c| reviewer[c]}
        STDOUT.flush
      end
    end

    puts "done"

  end

end
