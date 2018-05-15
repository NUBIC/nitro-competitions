# -*- encoding: utf-8 -*-
set :stage, :staging
set :rails_env, :staging

role :app, %w{vtfsmcdsiapps03.fsm.northwestern.edu}
role :web, %w{vtfsmcdsiapps03.fsm.northwestern.edu}
role :db,  %w{vtfsmcdsiapps03.fsm.northwestern.edu}

server 'vtfsmcdsiapps03.fsm.northwestern.edu', user: 'deploy', roles: %w{web app}, primary: true
