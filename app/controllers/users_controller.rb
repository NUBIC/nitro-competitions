# == Schema Information
#
# Table name: users
#
#  id                                      :integer          not null, primary key
#  username                                :string(255)      not null
#  era_commons_name                        :string(255)
#  first_name                              :string(255)      not null
#  last_name                               :string(255)      not null
#  middle_name                             :string(255)
#  email                                   :string(255)
#  degrees                                 :string(255)
#  name_suffix                             :string(255)
#  business_phone                          :string(255)
#  fax                                     :string(255)
#  title                                   :string(255)
#  employee_id                             :integer
#  primary_department                      :string(255)
#  campus                                  :string(255)
#  campus_address                          :text
#  address                                 :text
#  city                                    :string(255)
#  postal_code                             :string(255)
#  state                                   :string(255)
#  country                                 :string(255)
#  photo_content_type                      :string(255)
#  photo_file_name                         :string(255)
#  photo                                   :binary
#  biosketch_document_id                   :integer
#  first_login_at                          :datetime
#  last_login_at                           :datetime
#  password_salt                           :string(255)
#  password_hash                           :string(255)
#  password_changed_at                     :datetime
#  password_changed_id                     :integer
#  password_changed_ip                     :string(255)
#  created_id                              :integer
#  created_ip                              :string(255)
#  updated_id                              :integer
#  updated_ip                              :string(255)
#  deleted_at                              :datetime
#  deleted_id                              :integer
#  deleted_ip                              :string(255)
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  notify_on_new_submission                :boolean          default(TRUE)
#  notify_on_complete_submission           :boolean          default(TRUE)
#  encrypted_password                      :string           default(""), not null
#  reset_password_token                    :string
#  reset_password_sent_at                  :datetime
#  remember_created_at                     :datetime
#  sign_in_count                           :integer          default(0), not null
#  current_sign_in_at                      :datetime
#  last_sign_in_at                         :datetime
#  current_sign_in_ip                      :inet
#  last_sign_in_ip                         :inet
#  oauth_name                              :string
#  remember_token                          :string
#  should_receive_submission_notifications :boolean          default(TRUE)
#  system_admin                            :boolean
#

class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create, :login]
  before_action :set_project, only: [:new, :create]

  def login
    url = params[:url].blank? ? root_url : params[:url]
    if current_user && current_user.incomplete_record?
      url = edit_applicant_path(current_user)
    end
    redirect_to url
  end

  def new
    @sponsor = @project.program if @project
    if is_admin?(@sponsor) || current_user.system_admin?
      @user = User.new
    else
      redirect_to root_path, alert: 'Access Denied'    
    end
  end


  def create
    @sponsor = @project.program if @project
    if is_admin?(@sponsor) || current_user.system_admin?
      @user = User.new(user_params)
      @user.password = Devise.friendly_token[0,20] # unused but required by devise
      respond_to do |format|
        if @user.save
          flash[:notice] = 'User was successfully created.'
          format.html { redirect_to(reviewers_project_admins_path(@project)) } 
          format.xml  { head :ok }
        else
          format.html { render :action => :new }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: 'Access Denied'    
    end
  end

  # GET /users/:id.:format
  def show
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def set_project
      @project = current_project
    end

    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email)
    end
end
