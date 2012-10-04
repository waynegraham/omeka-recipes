Capistrano::Configuration.instance.load do
  set :shared_children, %w(system logs pids config archive)

  after 'deploy:finalize', 'deploy:like_a_boss'

  namespace :deploy do
    desc '|OmekaRecipes| Deploy omeka, github-style'
    task :default, :roles => :app, :except => { :no_release => true } do
      update
    end


    desc '|OmekaRecipes| Destroys everything'
    task :seppuku, :roles => :app, :except => { :no_release => true } do
      run "rm -rf #{current_path}; rm -rf #{shared_path}"
    end

    desc '|OmekaRecipes| Create shared dirs'
    task :setup_dirs, :roles => :app, :except => { :no_release => true } do
      commands = shared_dirs.map do |path|
        "mkdir -p #{shared_path}/#{path}"
      end
      run commands.join(" && ")
    end

    desc '|OmekaRecipes| Alias for symlinks:make'
    task :symlink, :roles => :app, :except => { :no_release => true } do
      symlinks.make
    end

    desc 'post install message'
    task :like_a_boss, :roles => :app, :except => { :no_release => true } do
      message = <<-eos
 ______________________
< Deployed like a boss >
 ----------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
eos
      puts message
    end

  end
end
