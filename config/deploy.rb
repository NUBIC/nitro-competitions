# -*- encoding: utf-8 -*-
set :application, 'nucats_assist'
set :repo_url, 'https://github.com/NUBIC/nucats_assist.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
# set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'

set :deploy_to, '/var/www/apps/nucats_assist'
set :deploy_via, :copy
# set :deploy_via, :remote_cache
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

# capistrano bundler properties
set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'
end
