module ReviewsHelper
  
	
	def review_comments_div(reviews, key_name)
    return "" if reviews.nil?
    s = ""

    reviews.each_with_index do |review, i|
      unless review[key_name].blank?
  		  s << ( '<div class="hanging-indent"> <span class="reviewer">Reviewer ' + (i+1).to_s + ':</span> '+ review[key_name].to_s + ' </div>' )
   	  end
 	  end
    s
  end
  
end
