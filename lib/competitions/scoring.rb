module Scoring
  # NIH research criteria
  DEFAULT_CRITERIA    = ['impact',
                         'team',
                         'innovation',
                         'scope',
                         'environment'].freeze

  ADDITIONAL_CRITERIA = ['budget',
                         'other',
                         'completion'].freeze

  # Combined criteria based on Project attributes
  CRITERIA = (DEFAULT_CRITERIA + ADDITIONAL_CRITERIA).freeze
end
