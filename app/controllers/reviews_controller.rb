class ReviewsController < ApplicationController
  
  # GET /submission/submission_id/reviews
  # GET /submission/submission_id/reviews.xml
  def index
    @submission = Submission.find(params[:submission_id])
    @reviews = @submission.submission_reviews
    if @reviews.nil?
      render :inline, "reviews not found"
    else
      respond_to do |format|
        format.html { render :layout=>'pdf' }# show.html.erb
        format.pdf do
           render :pdf => "Reviews: " + @submission.submission_title, 
              :stylesheets => ["pdf"], 
              :layout => "pdf"
        end
        format.xml  { render :xml => @reviews }
      end
    end
  end
  
  def update_item
    @submission_review = SubmissionReview.find(params[:id])
    if (@submission_review.reviewer_id == current_user_session.id and @submission_review.submission.project.review_end_date >=  (Date.today-1)) or is_admin? 
      if @submission_review.update_attributes(params[:submission_review])
        respond_to do |format|
          format.html { redirect_to submission_reviews(@submission_review.id) }
          format.js { 
            render :nothing => true 
           }
        end
      else
        respond_to do |format|
          format.html { redirect_to submission_reviews(@submission_review.id) }
          format.xml  { render :xml => @reviewer.errors, :status => :unprocessable_entity }
          format.js  { render :nothing => true }
        end
      end
    else
      flash[:notice] ||= ""
      flash[:notice] += "You either do not have permission to do this or else the review period has ended"
      redirect_to submission_reviews(@submission_review.id)
    end
  end
  
end
