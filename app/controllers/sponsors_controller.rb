class SponsorsController < ApplicationController

  #sponsor is really a program in the database
  helper :sponsors 
  include SponsorsHelper
  include ApplicationHelper
  
  # GET /sponsors
  # GET /sponsors.xml
  def index
    @sponsors = Program.order('lower(program_name)').to_a

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sponsors }
    end
  end

  # GET /sponsors/1
  # GET /sponsors/1.xml
  def show
    @sponsors = Program.where(id: params[:id]).to_a
    @sponsor  = @sponsors[0]
    @projects = @sponsor.projects
    set_current_project(@projects[0]) if @projects.length > 0
 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  def contact
    @contact = User.find(params[:id])
 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  def opt_out_submission_notification
    process_email_preference(false)
  end

  def opt_in_submission_notification
    process_email_preference(true)
  end

  def process_email_preference(val)
    @contact = User.find(params[:id])
    @contact.update_attribute(:should_receive_submission_notifications, val)
    flash[:notice] = 'Email preference was successfully updated.'
    redirect_to contact_sponsor_path(@contact)
  end
  private :process_email_preference

  # GET /sponsors/1/edit
  def edit
    @sponsor = Program.find(params[:id])
    respond_to do |format|
      if is_admin?(@sponsor)
        format.html # new.html.erb
        format.xml  { render :xml => @sponsor }
      else
        format.html { redirect_to(sponsors_path) }
        format.xml  { render :xml => @sponsor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sponsors/1
  # PUT /sponsors/1.xml
  def update
    @sponsor = Program.find(params[:id])
    respond_to do |format|
      if is_admin?(@sponsor) and @sponsor.update_attributes(program_params)
        flash[:notice] = 'Sponsor was successfully updated.'
        format.html { redirect_to(sponsor_path(@sponsor)) }
        format.xml  { head :ok }
      else
        format.html { render :action => :index }
        format.xml  { render :xml => @sponsor.errors, :status => :unprocessable_entity }
      end
    end
  end

  def program_params
    params.require(:program).permit(
      :program_name, 
      :email, 
      :program_title, 
      :program_url,
      :allow_reviewer_notification
    )
  end
  
end
