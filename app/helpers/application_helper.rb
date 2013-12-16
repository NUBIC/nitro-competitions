#encoding: UTF-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  require 'config' #adds allowed_ips list and do_ldap?

  def internetexplorer_user_agent?
    request.env["HTTP_USER_AGENT"] &&
    request.env["HTTP_USER_AGENT" ][/(MSIE)/]
  end

	# hard wired admin list:
	def act_as_admin
    session[:act_as_admin] = false
    if [ 'jab155','wakibbe','dfu601','super','jml237','cmc622' ].include?(current_user_session.username)  then
      session[:act_as_admin] = true
    end
  end

  # list of allowed IPs

  def disallowed_ip(this_ip)
    return false  #always allow!

    ips = allowed_ips() # from config.rb in project lib directory
    ips.each do |ip|
      if this_ip =~ /#{ip}/ then
        return false
      end
    end
    return true  #disallowed
  end


	# program and project session-oriented helpers

	def is_logged_in?
	  return false unless defined?(current_user)
	  begin
  	  return ! current_user.blank?
    rescue
    end
    return false
  end

	def current_program
    return current_project().program
  end

	def set_current_project(project)
	  if defined?(session) and ! session.nil?
	    session[:project_id] = project.id
    end
	  @@project = project
  end

  def set_session_project(project_id)
	  if defined?(session) and ! session.nil?
      session[:project_id] = project_id
    end
    if (defined?(@@project) and ! @@project.id.blank? and ! project_id.blank? and project_id != @@project.id)
      @@project = Project.find(project_id)
    end
    if (! defined?(@@project) or @@project.id.blank?)
      @@project = Project.find(project_id) unless project_id.blank?
    end
    current_project
  end

  def current_project
    begin
      if defined?(@@project)
        unless  (@@project).blank? or  (@@project).id.blank?
          return @@project
        end
      end
    rescue
    end
    @@project = handle_set_project
    return @@project
  end

  def handle_set_project
    if defined?(params)
      if !params[:project_id].blank?
        project = Project.find(params[:project_id])
      elsif !params[:id].blank? and self.controller_name == 'projects'
        project = Project.find(params[:id])
      elsif !params[:project_name].blank?
        project = Project.find_by_project_name(params[:project_name])
      elsif defined?(session) and ! session.nil? and ! session[:project_id].nil?
        project = Project.find(session[:project_id])
      end
    end
    project = Project.active[0] if project.nil? or project.blank?
    if project.blank?
      project = Project.new
    else
      if session[:project_id].nil? or session[:project_id] != project.id
        session[:project_id] = project.id
      end
    end
    # logger.error "handle_set_project called. project.id = #{project.id} and session[:project_id] = #{session[:project_id]}"
    project
  end

  def check_session
	  return unless defined?(session) and ! session.nil?
   begin
     if current_user.username.blank?
       puts "rats"
       logger.error("check_session. rats! current_user.username is blank!!!")
     end
   rescue
     logger.error("check_session. current_user is nil!!!")
   end
   if current_user.blank? or current_user.username.blank?
     clear_session_attributes()
   end

   if ! defined?(current_user_session) or current_user_session.blank? or current_user_session.username != current_user.username
     the_user = User.find_by_username(current_user.username)
     if the_user.blank? or the_user.name.blank?
       if make_user(current_user.username)
         flash[:notice] = 'User account was successfully created.'
         logger.error("check_session. current_user: #{current_user.username} was created")
         check_session
       else
         logger.error("check_session. Unable to create user account from LDAP registry for current_user: #{current_user.username}")
         flash[:notice] = 'Unable to create user account from LDAP registry.'
         make_user_from_login(current_user)
       end
       the_user = User.find_by_username(current_user.username)
     end
     unless the_user.blank? or the_user.id.blank?
       set_session_attributes(the_user)
     else
       clear_session_attributes()
     end
   else
     if session[:username].blank? or session[:user_id].blank? or session[:name].blank? or session[:username] != current_user_session.username
       the_user = User.find_by_username(current_user.username)
       unless the_user.blank?
         set_session_attributes(the_user)
       end
     end
   end

   if session[:program_id].blank?
     program = Program.find_by_program_name(default_program_name())
     session[:program_id] = program.id unless program.blank?
     # projects = program.projects.active unless program.blank?
   end

   if session[:act_as_admin].blank?
      act_as_admin
    end
  end

  def set_session_attributes(the_user)
	  return unless defined?(session) and ! session.nil?
    session[:username]   = the_user.username.to_s
    session[:name]       = the_user.name.to_s
    session[:user_era_commons_name] = the_user.era_commons_name.to_s
    session[:user_email] = the_user.email.to_s
    session[:user_id]    = the_user.id.to_s
    @current_user_session = the_user
    log_request("login")
  end

  def clear_session_attributes()
	  return unless defined?(session) and ! session.nil?
    session[:username]   = nil
    session[:name]       = nil
    session[:user_era_commons_name] = nil
    session[:user_email] = nil
    session[:user_id]    = nil
    @current_user_session = nil
    log_request("clear_session")
  end

  # Logging helper for the database activity log

  def log_request(activity=nil)
    return unless @logged.nil?
    @logged=true

	  return unless defined?(session) and ! session.nil?
    return if session[:user_id].blank?
    log_entry = Log.create(
        :user_id => session[:user_id],
        :activity => activity || self.controller_name + ":" + self.action_name,
        :project_id => current_project.id,
        :program_id => current_program.id,
        :controller_name => self.controller_name,
        :action_name => self.action_name,
        :created_ip => request.remote_ip,
        :params => (defined?(params) ? params.inspect : nil))
     log_entry.save
  end

  # format helpers

  def format_boolean(the_bool)
    the_bool ? 'Y': 'N'
  end
  def long_format_boolean(the_bool)
    the_bool ? 'Yes': 'No'
  end
  def format_date(the_date)
    the_date.nil? ? '' : the_date.to_s(:justdate)
  end
  def format_document_info(document)
    return '' if document.blank?
    document.file_file_name + ' was last saved on ' + format_date(document.last_updated_at || document.updated_at)
  end

  # before_ helpers
  def before_notify_email(model)
    model.notification_sent_at = Time.now
    begin
      model.notification_sent_by_id = current_user.id
      model.notification_sent_to = [current_user.email, submission.applicant.email].uniq.join(", ")
      model.notification_cnt += 1
    rescue Exception => error
      puts "before_notify_email - error: #{error.message}"
    end
  end

  def before_create(model)
    model.created_ip ||= request.remote_ip if defined?(request) and ! request.nil?
    model.created_id ||= session[:user_id] if defined?(session) and ! session.nil?
    before_update(model)
  end

  def before_update(model)
    model.updated_ip = request.remote_ip if defined?(request) and ! request.nil?
    model.updated_id = session[:user_id] if defined?(session) and ! session.nil?
  end

  def logged_in?
    !session[:user_id].blank?
  end

  def is_current_user?(id)
    id.to_i == session[:user_id].to_i
  end

  def handle_ldap(applicant)
    begin
      applicant  unless applicant.id.blank?
      applicant_in_db = User.find_by_username(applicant.username)
      return applicant_in_db unless applicant_in_db.blank? or applicant_in_db.id.blank?
      pi_data = GetLDAPentry(applicant.username) if do_ldap?
      if pi_data.nil?
        logger.warn("Probable error reaching the LDAP server in GetLDAPentry: GetLDAPentry returned null using netid #{applicant.username}.")
      elsif pi_data.blank?
          logger.warn("Entry not found. GetLDAPentry returned null using netid #{applicant.username}.")
      else
        ldap_rec=CleanPIfromLDAP(pi_data)
        applicant = BuildPIobject(ldap_rec) if applicant.id.blank?
        applicant=MergePIrecords(applicant,ldap_rec)
        if applicant.new_record?
          before_create(applicant)
          applicant.save!
        end
      end
     rescue Exception => error
       begin
         logger.error("Probable error reaching the LDAP server in GetLDAPentry: #{error.message}")
       rescue
         puts "Probable error reaching the LDAP server in GetLDAPentry: #{error.message}"
       end
    end
    applicant
  end

  def make_user(username)
    return nil if username.blank? or username.length < 3
    the_user = User.find_by_username(username)
    return the_user unless the_user.blank?
    the_user = User.new(:username => username)
    the_user = handle_ldap(the_user)
    the_user = add_user(the_user)
    return the_user unless the_user.blank? or the_user.id.blank?
    begin
      logger.info "Unable to find username #{username}"
    rescue
      puts "Unable to find username #{username}"
    end
    return false
  end

  def make_user_from_login(current_user)
    # for times when an authenticated user is not found in ldap!
    the_user = User.find_by_username(current_user.username)
    return the_user unless the_user.blank?
    email =  current_user.email
    email = current_user.username+"@unknown.edu" if email.blank?
    the_user = User.new(:username => current_user.username, :first_name=> current_user.first_name, :last_name=> current_user.last_name, :email=> email)
    the_user.save!
  end

  def add_user(the_user)
    return the_user unless the_user.new_record?
    before_create(the_user)
    if !the_user.last_name.blank? and the_user.save
      begin
        logger.info "user account #{the_user.username} #{the_user.name} successfully created"
      rescue
        puts "user account #{the_user.username} #{the_user.name} successfully created"
      end
      if the_user.created_id.blank? then
        the_user.created_id = the_user.id
        the_user.updated_id = the_user.id
        the_user.save
      end
    end
    the_user
  end


  def truncate_words(phrase, count=20)
    return "" if phrase.blank?
    re = Regexp.new('^(.{'+count.to_s+'}\w*)(.*)', Regexp::MULTILINE)
    phrase.gsub(re) {$2.empty? ? $1 : $1 + '...'}
  end

  def netid_lookup_tag()
    link_to(image_tag("search.gif", :style=> "margin-bottom:-5px;"), "http://directory.northwestern.edu/", :target => '_blank', :title=>"Click here to go to the Northwestern Directory to look up netids" )
	end

	def netid_lookup_observer(field_name)
	  observe_field( field_name,
			:frequency => 0.5,
			:update =>  {:success => field_name.to_s+"_id", :failure => 'flash_notice'},
			:before => "Element.show('spinner')",
			:complete => "Element.hide('spinner')",
			:url => {:controller=>'applicants', :action=>'username_lookup', :only_path => false},
			:with => "'username=' + encodeURIComponent(value)") +
			"<span id='#{field_name}_id'></span>"
	end

	def netid_lookup_function(field_name, include_span_tag=true)
    text =""
    text+= "<span id='#{field_name}_id'></span>" if include_span_tag
    if do_ajax? then
  	  text+= javascript_tag do
  	    remote_function( :update =>  {:success => field_name.to_s+"_id", :failure => 'flash_notice'},
      			:before => "Element.show('spinner')",
      			:complete => "Element.hide('spinner')",
      			:url => {:controller=>'applicants', :action=>'username_lookup', :only_path => false},
      			:with => "'username='+encodeURIComponent( $('"+field_name.to_s+"').getValue())")
      end
    end
    text
	end

	def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none;"
    end
    content_tag("div", attributes, &block)
  end

end
