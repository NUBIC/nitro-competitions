module KeyPersonnelHelper

  def key_personnel_lookup_observer(submission_id, root_name, index)
	  observe_field( root_name+'_username',
			:frequency => 0.5,
			:before => "Element.show('spinner')",
			:complete => "Element.hide('spinner')",
			:url => lookup_submission_key_personnel_path(submission_id),
			:with => "'username=' + encodeURIComponent(value) + '&role='+encodeURIComponent( $('"+root_name.to_s +
			    "_role').getValue()) + '&index='+encodeURIComponent("+index+")" ) +
			    "<span id='#{root_name}_username_id'></span>"
	end

  def add_key_person(user, submission_id=0, role="")
    submission_id = 0 if submission_id.blank?
    key = KeyPerson.where("user_id  = :user_id and submission_id = :submission_id", { :user_id => user.id, :submission_id => submission_id }).first
    if key.blank? or key.id.blank? then
      key = KeyPerson.new
      key.user_id          = user.id
      key.submission_id    = submission_id
      key.username         = user.username
      key.first_name       = user.first_name
      key.last_name        = user.last_name
      key.role             = role
      key.save! unless (submission_id.to_i < 1)
    else
      key.role            = role
      key.save!
    end
    key
  end


  def handle_key_personnel_param(submission)
    key_personnel_usernames = ""
    if defined?(params)
      unless params[:key_personnel].blank?
        key_personnel_usernames = params[:key_personnel].collect{ |x,y| y['username'] }
        submission.key_personnel.each do |key_person|
          key_person.destroy if key_personnel_usernames.blank? or !key_personnel_usernames.include?(key_person.username)
        end
        params[:key_personnel].each_value do |key_person|
           unless key_person["username"].blank? then
            # check if we have this user
            key_user = make_user(key_person["username"])
            if key_user.blank? then
              if ! key_person["username"].blank? and key_person["username"] =~ /^[a-zA-Z0-9\.\-\_][a-zA-Z0-9\.\-\_]+@[^\.]+\..+$/ and ! key_person["first_name"].blank? and ! key_person["last_name"].blank?
                key_user = User.new
                key_user.username           = key_person["username"]
                key_user.email              = key_person["username"]
                key_user.first_name         = key_person["first_name"]
                key_user.last_name          = key_person["last_name"]
                before_create(key_user)
                key_user.save!
                begin
                  logger.info "Making user with username #{key_user.username}"
                rescue
                  puts "Making user with username #{key_user.username}"
                end
              end
            end
            unless key_user.nil? or key_user.id.blank? or submission.id.blank?
              add_key_person(key_user, submission.id, key_person["role"])
            end
            unless key_user.nil? or key_user.id.blank? or key_person["uploaded_biosketch"].blank?
              key_user.uploaded_biosketch = key_person["uploaded_biosketch"]
              key_user.validate_email_attr = false
              key_user.save!
            end
          end
        end
      end
    end
  end

end
