# -*- coding: utf-8 -*-

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  require 'config'

  def blank_safe(word, filler = '-')
    return filler if word.blank?
    word
  end

  def internetexplorer_user_agent?
    request.env['HTTP_USER_AGENT'] && request.env['HTTP_USER_AGENT'][/(MSIE)/]
  end

  ##
  # Set session attribute act_as_admin
  def act_as_admin
    session[:act_as_admin] = current_user_is_admin?
  end

  def application_logout_path
    Rails.application.config.use_omniauth ? signout_path : logout_path
  end

  ##
  # Is the current user session username in the admin list
  # @return Boolean
  def current_user_is_admin?
    %w(wakibbe dfu601 super jml237 cmc622 pfr957).include?(current_user_session.try(:username))
  end
  private :current_user_is_admin?

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
    @@project = project
  end

  def set_session_project(project_id)
    session[:project_id] = project_id if session_exists?
    if project_set? && ! project_id.blank? && project_id != @@project.id
      @@project = Project.find(project_id)
    end
    if (!defined?(@@project) || @@project.id.blank?)
      @@project = Project.find(project_id) unless project_id.blank?
    end
    current_project
  end

  def current_project
    return @@project if project_set?

    @@project = handle_set_project
    @@project
  end

  def project_set?
    defined?(@@project) && ! @@project.blank? && ! @@project.id.blank?
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
    project = Project.active[0] if project.blank?
    if project.blank?
      project = Project.new
    else
      session[:project_id] = project.id if session[:project_id].nil? || session[:project_id] != project.id
    end
    # logger.error "handle_set_project called. project.id = #{project.id} and session[:project_id] = #{session[:project_id]}"
    project
  end

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
      the_user = User.find_by_username(current_user.username)
      if the_user.blank? || the_user.name.blank?
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
      if !the_user.blank? || !the_user.id.blank?
        set_session_attributes(the_user)
      else
        clear_session_attributes
      end
    else
      if session[:username].blank? || session[:user_id].blank? || session[:name].blank? || session[:username] != current_user_session.try(:username)
        the_user = User.find_by_username(current_user.try(:username))
        set_session_attributes(the_user) unless the_user.blank?
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

  def set_session_attributes(the_user, omniauth = nil)
    return unless session_exists?
    session[:username]   = the_user.username.to_s
    session[:name]       = the_user.name.to_s
    session[:user_era_commons_name] = the_user.era_commons_name.to_s
    session[:user_email] = the_user.email.to_s
    session[:user_id]    = the_user.id.to_s
    session[:user_info]  = omniauth if omniauth
    @current_user_session = the_user
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
    model.created_id ||= session[:user_id] if session_exists?
    before_update(model)
  end

  def before_update(model)
    model.updated_ip = request.remote_ip if request_exists?
    model.updated_id = session[:user_id] if session_exists?
  end

  def logged_in?
    !session[:user_id].blank?
  end

  def is_current_user?(id)
    id.to_i == session[:user_id].to_i
  end

  def handle_ldap(applicant)
    begin
      applicant unless applicant.id.blank?
      applicant_in_db = User.find_by_username(applicant.username)
      return applicant_in_db unless applicant_in_db.blank? || applicant_in_db.id.blank?
      pi_data = GetLDAPentry(applicant.username) if do_ldap?
      if pi_data.nil?
        logger.warn("Probable error reaching the LDAP server in GetLDAPentry: GetLDAPentry returned null using netid #{applicant.username}.")
      elsif pi_data.blank?
        logger.warn("Entry not found. GetLDAPentry returned null using netid #{applicant.username}.")
      else
        ldap_rec = CleanPIfromLDAP(pi_data)
        applicant = BuildPIobject(ldap_rec) if applicant.id.blank?
        applicant = MergePIrecords(applicant, ldap_rec)
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
    return nil if username.blank? || username.length < 3
    the_user = User.find_by_username(username)
    return the_user unless the_user.blank?
    the_user = User.new(username: username)
    the_user = handle_ldap(the_user)
    the_user = add_user(the_user)
    return the_user unless the_user.blank? || the_user.id.blank?
    begin
      logger.info "Unable to find username #{username}"
    rescue
      puts "Unable to find username #{username}"
    end
    false
  end

  def make_user_from_login(current_user)
    # for times when an authenticated user is not found in ldap!
    the_user = User.find_by_username(current_user.username)
    return the_user unless the_user.blank?
    email =  current_user.email
    email = current_user.username + '@unknown.edu' if email.blank?
    create_user(current_user, email)
  end

  def create_user(user, email)
    the_user = User.new(username: user.username,
                        first_name: user.first_name,
                        last_name: user.last_name,
                        email: email)
    the_user.save!
  end

  def add_user(the_user)
    return the_user unless the_user.new_record?
    before_create(the_user)
    if !the_user.last_name.blank? && the_user.save
      begin
        logger.info "user account #{the_user.username} #{the_user.name} successfully created"
      rescue
        puts "user account #{the_user.username} #{the_user.name} successfully created"
      end
      if the_user.created_id.blank?
        the_user.created_id = the_user.id
        the_user.updated_id = the_user.id
        the_user.save
      end
    end
    the_user
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

  def hidden_div_if(condition, attributes = {}, &block)
    attributes['style'] = 'display: none;' if condition
    content_tag('div', attributes, &block)
  end

  def omniauth_config
    @omniauth_config ||= OmniAuthConfigure.configuration.parameters_for(:nucats_assist, :nucats_accounts)
  end

  def oauth_provider_uri
    URI(provider_site)
  end

  def provider_site
    omniauth_config[:client_options][:site]
  end

  def client_id
    omniauth_config[:client_id]
  end

  def client_secret
    omniauth_config[:client_secret]
  end

  def cookie_key
    omniauth_config[:client_options][:cookie_key]
  end

end
