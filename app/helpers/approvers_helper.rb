module ApproversHelper
  def link_to_approval(submission)
    if submission.effort_approval_at.nil?
      link_to_remote('Approve', :url => project_approver_path(:project_id=>submission.project_id, :id=>submission.id), :method => :put, :title=>"Click here to approve the effort and institutional match (if any) for this submission" )
    else
      "#{format_date(submission.effort_approval_at)}"
    end
	end
  
end
