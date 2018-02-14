# -*- coding: utf-8 -*-

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  require 'config'

  def page_title(page_title, show_title = true)
    @show_title = show_title
    content_for(:page_title) { page_title.to_s }
  end

  def show_title?
    @show_title == true
  end

  def blank_safe(word, filler = '-')
    word.blank? ? filler : word
  end

  ##
  # Fixing issue with the Rails helper method on
  # staging and production servers
  def reviewer_assignment_url(project)
    url = project_reviewers_url(project)
    if Rails.application.config.use_nu
      path = "projects/#{project.id}/reviewers"
      case Rails.env
      when 'development'
        host = 'http://nucats-assist.dev.example.com/'
      when 'staging'
        host = 'https://nucats-assist-staging.nubic.northwestern.edu/'
      when 'production'
        host = 'https://grants.nubic.northwestern.edu/'
      end
      url = "#{host}#{path}"
    end
    url
  end

  ##
  # Handle google provider discrepancy
  # @param [Symbol]
  # @return [Symbol]
  def omniauth_provider(provider)
    provider == :google ? :google_oauth2 : provider
  end

  def internetexplorer_user_agent?
    request.env['HTTP_USER_AGENT'] && request.env['HTTP_USER_AGENT'][/(MSIE)/]
  end

  ##
  # Set session attribute act_as_admin
  def act_as_admin(user = current_user)
    session[:act_as_admin] = user.system_admin?
  end

  def application_logout_path
    signout_path
  end

  # program and project session-oriented helpers

  def is_logged_in?
    return false unless defined?(current_user)
    !current_user.blank?
  end

  def current_program
    current_project.try(:program)
  end

  def set_current_project(project)
    session[:project_id] = project.id if defined?(session) && !session.nil?
    @project = project
  end

  def set_session_project(project_id)
    session[:project_id] = project_id if session_exists?
    if project_set? && ! project_id.blank? && project_id != @project.id
      @project = Project.find(project_id)
    end
    if (!defined?(@project) || @project.id.blank?)
      @project = Project.find(project_id) unless project_id.blank?
    end
    current_project
  end

  def current_project
    return @project if project_set?

    @project = handle_set_project
    @project
  end

  def project_set?
    defined?(@project) && ! @project.blank? && ! @project.id.blank? && Project.exists?(@project.id)
  end

  def handle_set_project
    if defined?(params)
      if !params[:project_id].blank?
        project = Project.find(params[:project_id])
      elsif !params[:id].blank? && controller_name == 'projects'
        project = Project.find(params[:id])
      elsif !params[:project_name].blank?
        project = Project.find_by_project_name(params[:project_name])
      elsif defined?(session) && ! session.nil? && ! session[:project_id].nil?
        project = Project.find(session[:project_id])
      end
    end
    # Default project on login!!! Sometimes causes issue.
    project = Project.active[0] if project.blank?
    if project.blank?
      project = Project.new
    else
      session[:project_id] = project.id if session[:project_id].nil? || session[:project_id] != project.id
    end
    # logger.error "handle_set_project called. project.id = #{project.id} and session[:project_id] = #{session[:project_id]}"
    project
  end

  ##
  # Here we check the session for the user who is placed into the @current_user_session variable
  # if a User record is found by the username in the session.
  #
  # There is a whole lot of checking the database via User.find_by_username(current_user.username)
  # and checking of session attributes. This is followed by a number of create user and set session calls.
  #
  # The method to set this variable (set_session_attributes) is called at the end of this method
  # if the current_user was not put into the session previously.
  #
  # @see ApplicationController#current_user_session
  # @see ApplicationController#set_current_user_session
  # @see make_user
  # @see make_user_from_login
  def check_session
    return unless session_exists?
    begin
      if current_user.username.blank?
        puts 'rats'
        logger.error('check_session. rats! current_user.username is blank!!!')
      end
    rescue
      logger.error('check_session. current_user is nil!!!')
    end
    clear_session_attributes if current_user.blank? || current_user.username.blank?

    if !defined?(current_user_session) || current_user_session.blank? || current_user_session.try(:username) != current_user.try(:username)
      user = User.find_by_username(current_user.username)
      if user.blank? || user.name.blank?
        #
        # The current_user has logged in successfully but there is no user with that unique username in the users table
        # so here we make a new user with that username
        # and then call this method again
        #
        if make_user(current_user.username)
          flash[:notice] = 'User account was successfully created.'
          logger.error("check_session. current_user: #{current_user.username} was created")
          check_session
        else
          logger.error("check_session. Unable to create user account from LDAP registry for current_user: #{current_user.username}")
          flash[:notice] = 'Unable to create user account from LDAP registry.'
          make_user_from_login(current_user)
        end
        user = User.find_by_username(current_user.username)
      end
      if !user.blank? || !user.id.blank?
        set_session_attributes(user)
      else
        clear_session_attributes
      end
    else
      if session[:username].blank? || session[:user_id].blank? || session[:name].blank? || session[:username] != current_user_session.try(:username)
        user = User.find_by_username(current_user.try(:username))
        set_session_attributes(user) unless user.blank?
      end
    end
    if session[:program_id].blank?
      program = Program.find_by_program_name(default_program_name)
      session[:program_id] = program.id unless program.blank?
    end

    act_as_admin if session[:act_as_admin].blank?
  end

  def session_exists?
    defined?(session) && ! session.nil?
  end

  def request_exists?
    defined?(request) && ! request.nil?
  end

  def set_session_attributes(user, omniauth = nil)
    return unless session_exists?
    session[:username]   = user.username.to_s
    session[:name]       = user.name.to_s
    session[:user_era_commons_name] = user.era_commons_name.to_s
    session[:user_email] = user.email.to_s
    session[:user_id]    = user.id.to_s
    session[:user_info]  = omniauth if omniauth
    @current_user_session = user
    act_as_admin if session[:act_as_admin].blank?
    log_request('login')
  end

  def clear_session_attributes
    return unless session_exists?
    session[:username]   = nil
    session[:name]       = nil
    session[:user_era_commons_name] = nil
    session[:user_email] = nil
    session[:user_id]    = nil
    session[:user_info]  = nil
    session[:project_id] = nil
    @current_user_session = nil
    log_request('clear_session')
  end

  # Logging helper for the database activity log

  def log_request(activity = nil)
    return unless @logged.nil?
    @logged = true

    return unless session_exists?
    return if session[:user_id].blank?
    return if current_program.blank? || current_project.blank?
    log_entry = Log.create(
        user_id: session[:user_id],
        activity: activity || controller_name + ':' + action_name,
        project_id: current_project.id,
        program_id: current_program.id,
        controller_name: controller_name,
        action_name: action_name,
        created_ip: request.remote_ip,
        params: (defined?(params) ? params.inspect : nil))
     log_entry.save
  end

  # format helpers

  def format_boolean(the_bool)
    the_bool ? 'Y' : 'N'
  end

  def long_format_boolean(the_bool)
    the_bool ? 'Yes' : 'No'
  end

  def format_date(the_date)
    the_date.nil? ? '' : the_date.to_s(:justdate)
  end

  def format_document_info(document)
    return '' if document.blank?
    document.file_file_name + ' was last saved on ' + format_date(document.last_updated_at || document.updated_at)
  end

  # before_ helpers
  def before_create(model)
    model.created_ip ||= request.remote_ip if request_exists?
    model.created_id ||= current_user.id if current_user
    before_update(model)
  end

  def before_update(model)
    model.updated_ip = request.remote_ip if request_exists?
    model.updated_id = current_user.id if current_user
  end

  def logged_in?
    !current_user.blank?
  end

  def is_current_user?(id)
    id.to_i == current_user.id if current_user
  end

  def current_user_can_edit_submission?(submission)
    is_current_user?(submission.created_id) || is_current_user?(submission.applicant_id)
  end

  def handle_ldap(applicant)
    begin
      # return applicant if already persisted in database
      applicant unless applicant.id.blank?
      # or if we can locate applicant in the database
      applicant_in_db = find_user_in_db(applicant.username, applicant.email)
      return applicant_in_db unless applicant_in_db.blank? || applicant_in_db.id.blank?
      # get data for user from LDAP
      pi_data = GetLDAPentry(applicant.username) if do_ldap?
      if pi_data.nil?
        logger.warn("Probable error reaching the LDAP server in GetLDAPentry: GetLDAPentry returned null using netid #{applicant.username}.")
      elsif pi_data.blank?
        logger.warn("Entry not found. GetLDAPentry returned null using netid #{applicant.username}.")
      else
        ldap_rec  = CleanPIfromLDAP(pi_data)
        applicant = BuildPIobject(ldap_rec) if applicant.id.blank?
        applicant = MergePIrecords(applicant, ldap_rec)
        if applicant.new_record?
          applicant.password = Devise.friendly_token[0,20] if applicant.password.blank?
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

  def find_user_in_db(username, email)
    user = User.where(username: username).first
    user = User.where(email: email).first if user.blank? && !email.blank?
    user
  end

  def make_user(username, email = nil)
    return nil if username.blank? || username.length < 3
    user = find_user_in_db(username, email)
    return user unless user.blank?

    user = User.new(username: username)
    user.email = email unless email.blank?
    user = handle_ldap(user)
    user = add_user(user)
    return user unless user.blank? || user.id.blank?
    begin
      logger.info "Unable to find username #{username}"
    rescue
      puts "Unable to find username #{username}"
    end
    false
  end

  def make_user_from_login(current_user)
    # for times when an authenticated user is not found in ldap!
    user = User.where(username: current_user.username).first
    return user unless user.blank?
    email = current_user.email
    email = current_user.username + '@unknown.edu' if email.blank?
    create_user(current_user, email)
  end

  def create_user(user, email)
    user = User.new(username: user.username,
                    first_name: user.first_name,
                    last_name: user.last_name,
                    email: email)
    user.save!
  end

  def add_user(user)
    return user unless user.new_record?
    before_create(user)
    if !user.last_name.blank? && user.save
      begin
        logger.info "user account #{user.username} #{user.name} successfully created"
      rescue
        puts "user account #{user.username} #{user.name} successfully created"
      end
      if user.created_id.blank?
        user.created_id = user.id
        user.updated_id = user.id
        user.save
      end
    end
    user
  end

  def truncate_words(phrase, count = 20)
    return '' if phrase.blank?
    re = Regexp.new('^(.{' + count.to_s + '}\w*)(.*)', Regexp::MULTILINE)
    phrase.gsub(re) {$2.empty? ? $1 : $1 + '...'}
  end

  def netid_lookup_tag
    link_to(image_tag('search.gif', style: 'margin-bottom:-5px;'),
            NucatsAssist.ldap_url,
            target: '_blank',
            title: NucatsAssist.ldap_link_title)
  end

  def username_lookup_tag
    link_to(image_tag('search.gif', style: 'margin-bottom:-5px;'),
            '/admins/user_lookup',
            target: '_blank',
            title: NucatsAssist.ldap_link_title)
  end

  def hidden_div_if(condition, attributes = {}, &block)
    attributes['style'] = 'display: none;' if condition
    content_tag('div', attributes, &block)
  end

  def footer_contact
    Rails.logger.debug "RAILS DEBUGGER footer_contact - controller = #{controller_name}"
    Rails.logger.debug "RAILS DEBUGGER footer_contact - action     = #{action_name}"
    return render 'shared/sponsor_contact_information' if (controller_name == 'projects' && action_name != 'index') || controller_name == 'submissions' && action_name != 'all'
  end

end
