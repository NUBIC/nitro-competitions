namespace :merge_users do
  task :duplicate_usernames => :environment do
    # User.select(:id, :username).each { |user| user.username.upcase! }.group_by { |user| user.username }.select { |username, users| users.count > 1 }
    final_list = []
    all_users = User.all.map(&:username)
    all_users.map!(&:downcase)
    duplicates = all_users.select{ |u| all_users.count(u) > 1 }

    duplicates.each do |duplicate|
     record = User.where("lower(username) = ?", duplicate.downcase).select("id, last_name, first_name, username, email")
     final_list << record
    end
    final_list.each_with_index do |duplicate, index|
      puts index
      puts duplicate.inspect
    end
  end

  task :replace_duplicate, [:correct_user_id, :duplicate_user_id] => :environment do |t, args|
    #[keep, udpate]
    correct_user_id = args.correct_user_id
    duplicate_user_id = args.duplicate_user_id

    standard_columns = ['created_id', 'updated_id', 'deleted_id'].freeze

    tables_columns = {
                        'Submission' => ['applicant_id', 'notification_sent_by_id', standard_columns],
                        'Program' => standard_columns,
                        'Project' => standard_columns,
                        'Reviewer' => ['user_id', standard_columns],
                        'RolesUser' => ['user_id', standard_columns],
                        'SubmissionReview' => [standard_columns],
                        'KeyPerson' => ['user_id'],
                        'Identity' => ['user_id'],
                        'FileDocument' => ['created_id', 'updated_id']
                      }

    # notification_sent_to is stored as a string, so run this separately
    puts "Submission.where('notification_sent_to = #{duplicate_user_id}').update_all('notification_sent_to = #{correct_user_id}')"
    Submission.where("notification_sent_to = '#{duplicate_user_id}'").update_all("notification_sent_to = #{correct_user_id}")
    tables_columns.each do |table, columns|
      columns.flatten.each do |column|
        puts "#{table}.constantize.where('#{column} = #{duplicate_user_id}').update_all('#{column} = #{correct_user_id}')"
        table.constantize.where("#{column} = #{duplicate_user_id}").update_all("#{column} = #{correct_user_id}")
      end
    end
    if User.where(id: duplicate_user_id).exists?
      duplicate_user = User.find(duplicate_user_id)
      new_username = duplicate_user.username.prepend("archived_")
      duplicate_user.update_columns(username: new_username)
    end
    if User.where(id: correct_user_id).exists?
      correct_user = User.find(correct_user_id)
      new_username = correct_user.username.strip if correct_user.username.respond_to?(:strip)
      new_username.downcase!
      correct_user.update_columns(username: new_username)
    end
  end
end
