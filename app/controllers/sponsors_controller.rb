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
      if is_admin?(@sponsor) and  @sponsor.update_attributes(params[:program])
        flash[:notice] = 'Sponsor was successfully updated.'
        format.html { redirect_to(sponsor_path(@sponsor)) }
        format.xml  { head :ok }
      else
        format.html { render :action => :index }
        format.xml  { render :xml => @sponsor.errors, :status => :unprocessable_entity }
      end
    end
  end

  
end
