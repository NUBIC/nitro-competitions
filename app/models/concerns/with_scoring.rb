module WithScoring
  extend ActiveSupport::Concern

  # NIH research criteria
  DEFAULT_CRITERIA    = ['impact',
                         'team',
                         'innovation',
                         'scope',
                         'environment'].freeze

  ADDITIONAL_CRITERIA = ['budget',
                         'other',
                         'completion'].freeze

  # All possible composite criteria -- based on Project attributes
  COMPOSITE_CRITERIA = (DEFAULT_CRITERIA + ADDITIONAL_CRITERIA).freeze

  ALL_REVIEW_CRITERIA = (COMPOSITE_CRITERIA + ['overall_impact']).freeze

  def calculate_average scores
    return 0 if scores.empty?
    (scores.sum.to_f / scores.size).round(2)
  end
end
