# -*- encoding: utf-8 -*-
set :stage, :demo
set :rails_env, :demo
set :deploy_to, '/var/www/apps/nitro-competitions'
set :linked_files, []
set :bundle_flags, '--deployment --quiet -- --with-pg-config=/usr/pgsql-9.3/bin/pg_config'

role :app, %w{grants-demo.nubic.northwestern.edu}
role :web, %w{grants-demo.nubic.northwestern.edu}
role :db,  %w{grants-demo.nubic.northwestern.edu}

server 'grants-demo.nubic.northwestern.edu', user: 'deploy', roles: %w{web app}, primary: true

