# -*- encoding: utf-8 -*-
set :stage, :production
set :rails_env, :production

role :app, %w{rails-prod2.nubic.northwestern.edu}
role :web, %w{rails-prod2.nubic.northwestern.edu}
role :db,  %w{rails-prod2.nubic.northwestern.edu}

server 'rails-prod2.nubic.northwestern.edu', user: 'nitrocompetitions', roles: %w{web app}, primary: true
