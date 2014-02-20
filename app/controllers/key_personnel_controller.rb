class KeyPersonnelController < ApplicationController

  include KeyPersonnelHelper

  # for rjs call on form
  def lookup
    dom_id = 'key_personnel_'+params[:index]
    begin
      raise NameError, "set username" if params[:username].blank?
      raise NameError, "set submission_id" if params[:submission_id].nil?
      raise NameError, "set role" if params[:role].nil?
      raise NameError, "set id" if params[:index].nil?
      applicant = User.new(:username=>params[:username])
      submission = Submission.find(params[:submission_id])
      applicant = handle_ldap(applicant)
      raise StandardError, "<i>#{params[:username]}</i> not found" if applicant.last_name.blank?
      if applicant.new_record?
        add_user(applicant)
      end
      key = add_key_person(applicant, params[:submission_id], params[:role])
      render :update do |page|
        page.replace_html dom_id, :partial=>'shared/personnel_fields', :layout=>false, :locals=>{:key_person=>key, :submission=>submission, :index=>params[:index]}
      end
    rescue StandardError => error
      render :update do |page|
        page.replace_html dom_id+"_username_id", :inline => "<span style='color:green;'>#{error.message}</span>"
      end
     rescue Exception => error
       render :update do |page|
         page.replace_html 'errors', :inline => "<span style='color:red;'>#{error.message}</span>"
       end
    end
  end

  # for rjs call on form
  def add_new
    @submission = Submission.find(params[:submission_id])
    @key_person = KeyPerson.new
  end

  def destroy
    if params[:id].to_i > 0
      @key_person = KeyPerson.find(params[:id])
      @key_person.destroy
    end
  end
end
