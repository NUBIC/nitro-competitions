module AdminsHelper
  def render_view_activities
    if has_read_all?(@sponsor) then
       respond_to do |format|
        format.html { render :view_activities }
        format.xml  { render :xml => @logs }
      end
    else
      redirect_to projects_path
    end
  end
end
