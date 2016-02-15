# -*- coding: utf-8 -*-
module ReviewsHelper

  def review_comments_div(reviews, key)
    return '' if reviews.nil?
    s = ''

    key_text  = "#{key}_text"
    key_score = "#{key}_score"

    reviews.each_with_index do |review, i|
      if !review[key_text].blank? || !review[key_score].blank?
        content = build_reviewer_info(review, i) + 
                  build_comment(review, key_text, key_score)
        s << content_tag(:div, content, class: 'hanging-indent')
      end
    end
    s
  end

  def build_reviewer_info(review, i)
    content = "Reviewer  #{(i + 1)}:"
    is_admin? ?
      content_tag(:span, content, class: 'reviewer', title: review.reviewer.name) :
      content_tag(:span, content, class: 'reviewer')
  end

  def build_comment(review, key_text, key_score)
    review.project.show_review_scores_to_reviewers ?
      " [#{review[key_score]}] #{review[key_text]}" :
      " #{review[key_text]}"
  end

end
