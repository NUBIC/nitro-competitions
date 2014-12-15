# -*- encoding: utf-8 -*-
set :stage, :demo
set :rails_env, :demo

role :app, %w{grants-demo.nubic.northwestern.edu}
role :web, %w{grants-demo.nubic.northwestern.edu}
role :db,  %w{grants-demo.nubic.northwestern.edu}

server 'grants-demo.nubic.northwestern.edu', user: 'deploy', roles: %w{web app}, primary: true
