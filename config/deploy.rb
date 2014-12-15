# -*- encoding: utf-8 -*-
set :application, 'nucats_assist'
set :repo_url, 'https://github.com/NUBIC/nitro-arm.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/apps/nucats_assist'
set :deploy_via, :copy
set :scm, :git

set :linked_files, %w{.env}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets public/system}

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

  namespace :symlink do
    task :database_config do
      on roles(:web) do
        execute "ln -nfs /etc/nubic/db/nitro_competitions.yml #{release_path}/config/database.yml"
      end
    end
  end
  before 'deploy:assets:precompile', 'deploy:symlink:database_config'
end
