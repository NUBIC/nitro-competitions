namespace :users do
  # TODO: Run update all records through LDAP????

  desc 'Finds the duplicate username records.'
  task :find_duplicate_usernames => :environment do
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

  desc 'Processes duplicate user records Arguments = [keep, udpate].'
  task :process_duplicate_user, [:correct_user_id, :duplicate_user_id] => :environment do |t, args|
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
  
  desc 'Prints all users with type = nil.'
  # The results from the following task can be searched in LDAP individually
  # from the console with the following command.
  # Devise::LDAP::Connection.new.ldap.search(filter: Net::LDAP::Filter.eq('mail', '<INSERT SEARCH EMAIL>')).first
  task find_type_nil_users: :environment do
    nil_users = User.where(type: nil)
    puts nil_users.map{|user| [user.id, user.username, user.first_name, user.last_name, user.email]}
    puts "Count: #{nil_users.count}"
  end

  desc 'Assign user type to existing users'
  task assign_user_type: :environment do
    update_users_in_identity_table
    update_remaining_nu_users
    update_remaining_external_users

    unassigned_count = User.where(type: nil).count
  end

  def update_array_of_users users, user_type
    User.where("id IN (?)", users).update_all(type: user_type)
  end

  def update_users_in_identity_table
    update_nu_identity_users
    update_external_identity_users
  end

  def update_nu_identity_users
    ldap_users = Identity.joins(:user).where("uid LIKE (?)", "nu%").pluck(:user_id)
    update_array_of_users(ldap_users, 'LdapUser')
  end

  def update_external_identity_users
    ext_users_ids = Identity.joins(:user).where.not("uid LIKE (?)", "nu%").pluck(:user_id)
    update_array_of_users(ext_users_ids, 'ExternalUser')

    ext_users = User.where("id IN (?)", ext_users_ids)
    ext_users.each { |user| user.update_attribute(:username, user.email) }
  end

  def update_remaining_nu_users
    netid_users = User.where(type: nil).where.not("username LIKE (?)", "%@%").pluck(:id)
    update_array_of_users(netid_users, 'LdapUser')
    
    northwestern_email_users = User.where(type: nil).where("username LIKE (?)", "%@northwestern.edu")
    search_ldap_user_by_email(northwestern_email_users)
  end

  def search_ldap_user_by_email(users)
    ldap_connection = Devise::LDAP::Connection.new.ldap
    users.each do |user|
      ldap_entry = ldap_connection.search(filter: get_ldap_filter_by_email(user.username)).first
      process_ldap_entry(user, ldap_entry) if ldap_entry.present?
    end
  end

  def process_ldap_entry(user, ldap_entry)
    User.where(username: ldap_entry.uid.first).present? ? merge_users(user, ldap_entry) : set_ldap_user(user, ldap_entry)
  end

  def update_remaining_external_users
    ext_users = User.where(type: nil).where.not("username LIKE (?)", "%@northwestern.edu")
    ext_users.each { |user| set_external_user(user) }
  end

  def set_ldap_user(user, ldap_entry)
    user.type = 'LdapUser'
    user.username = ldap_entry.uid.first
    user.email = ldap_entry.mail.first
    user.save!
  end

  def merge_users(user,ldap_entry)
    user.update_attribute(:email, user.username)
    existing_user = User.where(username: ldap_entry.uid.first).first
    Rake::Task["users:process_duplicate_user"].invoke(existing_user.id,user.id)
    user.update_attribute(:type, 'ExternalUser')
  end


  def set_external_user(user)
    user.type = 'ExternalUser'
    user.email = user.username
    user.prepare_user
    user.save!
  end

  def get_ldap_filter_by_email(email)
    Net::LDAP::Filter.eq('mail', email)
  end
end
