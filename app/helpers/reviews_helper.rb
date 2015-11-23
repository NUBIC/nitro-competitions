# -*- coding: utf-8 -*-
module ReviewsHelper

  def review_comments_div(reviews, key_name)
    return '' if reviews.nil?
    s = ''

    reviews.each_with_index do |review, i|
      unless review[key_name].blank?

        reviewer_info = ' <span class="reviewer">Reviewer ' + (i + 1).to_s + ':</span> '
        if is_admin? 
          reviewer_info = ' <span class="reviewer" title="' + review.reviewer.name + '">Reviewer ' + (i + 1).to_s + ':</span> '
        end

        html = '<div class="hanging-indent">' + reviewer_info + 
               review[key_name].to_s +
               ' </div>'
        s << html
      end
    end
    s
  end

end
