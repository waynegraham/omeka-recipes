Capistrano::Configuration.instance.load do
  # these are set to the same structure in shared <=> current
  set :normal_symlinks, %w(files db.ini) unless exists?(:normal_symlinks)

  # weird symlinks go somewhere else
  set :weird_symlinks, {'db.ini' => 'db.ini.changeme'} unless exists?( :weird_symlinks )

  namespace :symlinks do

    desc "|OmekaRecipes| Make all the symlinks in a single run"
    task :make, :roles => :app, :except => { :no_release => true } do
      commands = normal_symlinks.map do |path|
        "rm -rf #{current_path}/#{path} && \
         ln -s #{shared_path}/#{path} #{current_path}/#{path}"
      end

      commands += weird_symlinks.map do |from, to|
        "rm -rf #{current_path}/#{to} && \
         ln -s #{shared_path}/#{from} #{current_path}/#{to}"
      end

      run <<-CMD
        cd #{current_path} && #{commands.join(" && ")}
      CMD
    end
  end

  after 'deploy:create_symlink', 'symlinks:make'
end
