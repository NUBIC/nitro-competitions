# -*- encoding: utf-8 -*-
set :stage, :production
set :rails_env, :production

role :app, %w{vfsmcdsiapps03.fsm.northwestern.edu}
role :web, %w{vfsmcdsiapps03.fsm.northwestern.edu}
role :db,  %w{vfsmcdsiapps03.fsm.northwestern.edu}

server 'vfsmcdsiapps03.fsm.northwestern.edu', user: 'deploy', roles: %w{web app}, primary: true
