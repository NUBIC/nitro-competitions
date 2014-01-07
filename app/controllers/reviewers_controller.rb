class ReviewersController < ApplicationController
  # GET /reviewers
  # GET /reviewers.xml
  before_filter :set_project

  def index
    set_session_project(params[:project_id]) unless params[:project_id].blank?
    @assigned_submission_reviews = current_user_session.submission_reviews.this_project(current_project.id)
    respond_to do |format|
      format.html { render :action => 'index' } # index.html.erb
      format.xml  { render :xml => @reviewers }
    end
  end

  def index_with_files
    @include_files = true
    index
  end

  def complete_listing
    set_session_project(params[:project_id]) unless params[:project_id].blank?
    show_to_reviewers  = current_project.show_composite_scores_to_reviewers || current_project.show_review_summaries_to_reviewers
    @assigned_submission_reviews = current_user_session.submission_reviews.this_project(current_project.id)
    if has_read_all?(current_program) || (@assigned_submission_reviews.length > 0 and show_to_reviewers)
      @submission_reviews = current_project.submission_reviews.all
    end
    respond_to do |format|
      format.html { render :action => 'index' } # index.html.erb
      format.xml  { render :xml => @reviewers }
    end
  end

  def complete_listing_with_files
    set_session_project(params[:project_id]) unless params[:project_id].blank?
    show_to_reviewers  = current_project.show_composite_scores_to_reviewers || current_project.show_review_summaries_to_reviewers
    @include_files = true
    @speed_display = true
    @assigned_submission_reviews = current_user_session.submission_reviews.this_project(current_project.id)
    if has_read_all?(current_program) || (@assigned_submission_reviews.length > 0 and show_to_reviewers)
      @submission_reviews = current_project.submission_reviews.all
    end
    respond_to do |format|
      format.html { render :action => 'index' }# index.html.erb
      format.xml  { render :xml => @reviewers }
    end
  end


  def all_reviews
    projects = Project.active(Date.today)
    @submission_reviews = current_user_session.submission_reviews.active(projects.collect(&:id))
    @submission_reviews_title = 'Historical reviews across all competitions'
    @include_competition=true
    respond_to do |format|
      format.html { render :index }# index.html.erb
      format.xml  { render :xml => @reviewers }
    end
  end

  # GET /reviewers/1/edit
  def edit
    @submission_review = SubmissionReview.find(params[:id])
    if @submission_review.submission.project.review_end_date < Date.today and is_admin?(current_program)
      flash[:errors] = "Sorry - You cannot save changes to this review! -  The review date for this competition is over. Please contact the administrator for the competition if you need to submit additional reviews!"
      render :edit
    elsif @submission_review.submission.project.review_end_date < Date.today
      flash[:errors] = "Sorry - You cannot save changes to this review! -  The review date for this competition is over. Please contact the administrator for the competition if you need to submit additional reviews!"
      redirect_to( project_reviewers_url(current_project) )
    elsif is_admin?(current_program) or @submission_review.reviewer_id == current_user_session.id
      respond_to do |format|
        format.html # edit.html.erb
        format.xml  { render :xml => @reviewer }
      end
    else
      if current_project.blank?
        redirect_to projects_path
      else
        redirect_to project_path(current_project.id)
      end
    end
  end


  # PUT /reviewers/1
  # PUT /reviewers/1.xml
  def update
    @submission_review = SubmissionReview.find(params[:id])
    if (@submission_review.reviewer_id == current_user_session.id and @submission_review.submission.project.review_end_date >=  Date.today) or is_admin?(@submission_review.submission.project.program)
      respond_to do |format|
        if @submission_review.update_attributes(params[:submission_review])
          flash[:notice] = 'Review was successfully updated.'
          format.html { redirect_to(project_reviewers_url(current_project)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @reviewer.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'You do not have update privileges or this review is past the edit cutoff.'
      redirect_to( project_reviewers_url(current_project) )
    end
  end

  def update_item
    @submission_review = SubmissionReview.find(params[:id])
    if (@submission_review.reviewer_id == current_user_session.id and @submission_review.submission.project.review_end_date >=  Date.today) or is_admin?
      respond_to do |format|
        if @submission_review.update_attributes(params[:submission_review])
          flash[:notice] = 'Review was successfully updated.'
          format.html { redirect_to(project_reviewers_url(current_program)) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @reviewer.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:notice] = 'You do not have update privileges or this review is past the edit cutoff.'
      redirect_to( project_reviewers_url(current_program) )
    end
  end

  # DELETE /reviewers/1
  # DELETE /reviewers/1.xml
  def destroy
    if is_admin?
      @reviewer = Reviewer.find(params[:id])
      @reviewer.destroy if is_admin?
    else
      flash[:notice] = 'You do not have delete priveleges.'
    end
    respond_to do |format|
      format.html { redirect_to(project_reviewers_url(current_program)) }
      format.xml  { head :ok }
    end
  end

  private

  def set_project
    unless params[:project_id].blank?
      @project = Project.find(params[:project_id])
      set_current_project(@project)
    end
  end
end
