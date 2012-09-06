Capistrano::Configuration.instance.load do
  #User settings
  
  set :user, 'deploy' unless exists?(:user)
  set :group, 'www-data' unless exists?(:group)

  set :runner, user
  set :scm, :git

  set :branch, 'master' unless exists?(:branch)

  set :deploy_to, "/usr/local/projects/#{application}" unless exists?(:deploy_to)
  set :deploy_via, :remote_cache
  set :keep_releases, 3
  set :git_enable_submodules, true

  set :use_sudo, false unless exists?(:use_sudo)

  default_run_options[:pty] = true

  set :using_rvm, true unless exists?(:using_rvm)

  if using_rvm
    $:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # add rvm lib to load path
    require 'rvm/capistrano' #load rvm capistrano plugin

    set :rvm_ruby_string, 'ree' unless exists?(:rvm_ruby_string)
  end

  set :shared_dirs, %w(archives) unless exists?(:shared_dirs)

  namespace :app do
    task :setup, :roles => :app do
      commands = shared_dirs.map do |path|
        "if [ ! -d '#{path}' ]; then mkdir -p #{path}; fi;"
      end

      run "cd #{shared_path}; #{commands.join(' ')}"

    end
  end
end
