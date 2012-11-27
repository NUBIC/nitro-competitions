class RolesController < ApplicationController

# I have modified the routes in a non-standard way


  # GET /sponsors/:sponsor_id/roles
  # GET /sponsors/:sponsor_id/roles.xml
  def index
    @sponsor = Program.find(params[:sponsor_id])
    if is_admin?(@sponsor)
      @roles = Role.all
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @roles }
      end
    else
      redirect_to(sponsor_path(params[:sponsor_id]))
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @sponsor = Program.find(params[:sponsor_id])
    if is_admin?(@sponsor)
      @role = Role.find(params[:id])
      @roles_users = @sponsor.roles_users.for_role(@role).all
      @all_users = User.all
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @role }
      end
    else
      redirect_to(sponsor_path(params[:sponsor_id]))
    end
  end

# /sponsors/:sponsor_id/roles/:role_id/users/:user_id/add(.:format)
#   add_sponsor_role_user_rest GET    /sponsors/:sponsor_id/roles/:role_id/users/:user_id/rest/:id/add(.:format)    {:controller=>"roles", :action=>"add"}

  def add
    @sponsor = Program.find(params[:sponsor_id])
    @role = Role.find(params[:role_id])

    if is_admin?(@sponsor)
      @roles_user = RolesUser.find(:first, :conditions => ["role_id = :role_id and user_id = :user_id and program_id = :program_id", {:user_id =>  params[:user_id], :role_id => params[:role_id], :program_id => params[:sponsor_id]}])
      @roles_user = RolesUser.new(:user_id=>params[:user_id], :role_id => @role.id, :program_id => params[:sponsor_id]) if @roles_user.blank?
 
      respond_to do |format|
        if @roles_user.new_record? && @roles_user.save
          flash[:notice] = "Role #{@role.name} was successfully created for user #{@roles_user.user.name}."
          format.html { redirect_to(sponsor_role_url(:sponsor_id=>params[:sponsor_id], :id=>params[:role_id])) }
          format.xml  { render :xml => @roles_user, :status => :created, :location => @role }
        else
          flash[:notice] = "Role #{@role.name} already existed for user #{@roles_user.user.name}."
          format.html { redirect_to(sponsor_role_url(:sponsor_id=>params[:sponsor_id], :id=>params[:role_id])) }
          format.xml  { render :xml => @roles_user, :status => :ok, :location => @role }
         end
      end
    else
      redirect_to(sponsor_path(params[:sponsor_id]))
    end
  end

#  remove_sponsor_role_user_rest GET    /sponsors/:sponsor_id/roles/:role_id/users/:user_id/rest/:id/remove(.:format) {:controller=>"roles", :action=>"remove"}

  def remove
    @sponsor = Program.find(params[:sponsor_id])
    @roles_user = RolesUser.find_by_id(params[:id])
    if @roles_user.blank?
      flash[:notice] = "Role could not be removed. (no longer exists)"
    end
    if is_admin?(@sponsor) and ! @roles_user.blank?
      @role = @roles_user.role
      @user = @roles_user.user
      @roles_user.destroy
      respond_to do |format|
        flash[:notice] = "Role #{@role.name} for user #{@user.name} was successfully removed."
        format.html { redirect_to(sponsor_role_url(:sponsor_id=>params[:sponsor_id], :id=>params[:role_id])) }
        format.xml  { render :xml => @role, :status => :deleted, :location => @role }
      end
    else
      redirect_to(sponsor_role_url(:sponsor_id=>params[:sponsor_id], :id=>params[:role_id]))
    end
  end

end
