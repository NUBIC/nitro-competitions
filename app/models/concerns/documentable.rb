module Documentable
  extend ActiveSupport::Concern

  # 4 Main Documents
  MAIN_DOCUMENTS      = ['document1',
                         'document2',
                         'document3',
                         'document4'].freeze

  ADDITIONAL_DOCUMENTS = ['budget',
                         'other',
                         'completion'].freeze

  # All possible composite criteria -- based on Project attributes
  COMPOSITE_DOCUMENTS = (MAIN_DOCUMENTS + ADDITIONAL_DOCUMENTS).freeze

  def calculate_average scores
    return 0 if scores.empty?
    (scores.sum.to_f / scores.size).round(2)
  end
end