class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :create]

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
          format.html { redirect_to(root_path) } 
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

    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email)
    end
end