Capistrano::Configuration.instance.load do
  # these are set to the same structure in shared <=> current
  set :normal_symlinks, %w(db.ini application/logs/ archive) unless exists?(:normal_symlinks)

  # weird symlinks go somewhere else
  set :weird_symlinks, {} unless exists?( :weird_symlinks )

  namespace :symlinks do
    desc "|OmekaRecipes| Make all the symlinks in a single run"
    task :make, :roles => :app, :except => { :no_release => true } do
      commands = normal_symlinks.map do |path|
        "rm -rf #{current_path}/#{path} && \
        ln -s #{shared_path}/#{path} #{current_path}/#{path}"
      end

      commands += weird_symlinks.amp do |from, to|
        "rm -rf #{current_path}/#{to} && \
        ln -s #{shared_path}/#{from} #{current_path}/#{to}"
      end

      run <<-CMD
        run #{current_path} && #{commands.join(" && ") }
      CMD
    end
  end


end
