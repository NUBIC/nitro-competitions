# -*- encoding: utf-8 -*-
set :stage, :staging
set :rails_env, :staging

role :app, %w{rails-staging2.nubic.northwestern.edu}
role :web, %w{rails-staging2.nubic.northwestern.edu}
role :db,  %w{rails-staging2.nubic.northwestern.edu}

server 'rails-staging2.nubic.northwestern.edu', user: 'nitrocompetitions, roles: %w{web app}, primary: true
