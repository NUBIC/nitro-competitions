# This file will need more work to incorporate it into the appplication

# These changes are here for rspec compatibility with rails 5.
RSpec.configure do |config|
  config.include Rails::Controller::Testing::TestProcess
  config.include Rails::Controller::Testing::TemplateAssertions
  config.include Rails::Controller::Testing::Integration
end