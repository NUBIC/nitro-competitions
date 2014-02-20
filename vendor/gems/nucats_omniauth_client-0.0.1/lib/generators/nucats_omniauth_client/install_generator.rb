# -*- encoding: utf-8 -*-
require 'rails/generators'

module NucatsOmniauthClient
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    desc 'Copies omniauth configuration files to your application.'

    def copy_files
      copy_file 'lib/nucats_membership.rb', 'lib/nucats_membership.rb'
      copy_file 'config/initializers/omniauth.rb', 'config/initializers/omniauth.rb'
    end

    def update_environment_dot_rb
      inject_into_file 'config/environment.rb', "\nrequire 'nucats_membership'\n", after: "require File.expand_path('../application', __FILE__)\n"
    end
  end
end