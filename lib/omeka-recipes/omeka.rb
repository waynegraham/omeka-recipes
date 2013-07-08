Capistrano::Configuration.instance.load do

  set :omeka_branch, "master" unless exists?(:omeka_branch)
  set :sync_directories, %w(files) unless exists?(:sync_directories)
  set :maintenance_basename, 'maitenance' unless exists?(:maintenance_basename)

  def git_clone(hash, directory)
    url = ''
    branch = ''
    hash.each do |repo_name|
      pp(repo_name)
      repo_name.each do |con|
        url = con['url']
        branch = con['branch']
        run "cd #{current_path}/#{directory} && rm -rf #{repo_name[0]}"
        run "cd #{current_path}/#{directory} && git clone #{url} #{repo_name[0]} --quiet"
        run "cd #{current_path}/#{directory} && git fetch --quiet && git checkout #{branch} --quiet" unless branch.to_s.empty?
      end
    end
  end

  def host_and_port
    return roles[:web].servers.first.host, ssh_options[:port] || roles[:web].servers.first.port || 22
  end

  namespace :omeka do
    desc '|OmekaRecipes| Ensure the files directory has write permissions'
    task :fix_files_permissions do
      # This _should_ actually change the permissions of the files directory to
      # be the owner of process running httpd/apache2 daemon.
      run "chmod -R 777 #{current_path}/files"
    end

    desc '|OmekaRecipes| Sync the assets directory to your local system'
    task :sync_assets, :roles => :web, :once => true, :except => { :no_release => true } do
      desc <<-DESC
OmekaRecipes Sync declared files from the selected multi_stage environment to
the local development environment. The synced directories must be declared as
an array of Strings with the sync_directories variable. The path is relative to
the root.
      DESC

      server, port = host_and_port
      Array(fetch(:sync_directories, [])).each do |syncdir|
        puts syncdir
        unless File.directory? "#{syncdir}"
          logger.info "creating local '#{syncdir}' folder"
          FileUtils.mkdir_p "#{syncdir}"
        end

        logger.info "sync #{syncdir} from #{server}:#{port} to local"
        destination, base = Pathname.new(syncdir).split
        system "rsync --verbose --archive --compress --copy-links --delete --stats --rsh='ssh -p #{port}' #{user}@#{server}:#{current_path}/#{syncdir} #{destination.to_s}"
      end
      logger.important "sync filesystem from the stage '#{stage}' to local complete."
    end

    desc '|OmekaRecipes| Rename files'
    # Omeka stages these files in its repo
    task :rename_files do
      run "cd #{current_path} && mv .htaccess.changeme .htaccess"
      run "cd #{current_path}/application/config && mv config.ini.changeme config.ini"
    end

    desc '|OmekaRecipes| Move the files directory out of the way'
    task :move_files do
      run "mv #{current_path}/files #{current_path}/files_deleteme"
    end

    desc '|OmekaRecipes| Link the files directoy for the project'
    task :link_files_dir, :except => {:no_release => true} do
      run "cd #{current_path} && ln -snf #{shared_path}/files"
    end

    desc '|OmekaRecipes| Add the db.ini to the shared directory'
    task :db_ini do
      run "touch #{shared_path}/db.ini"
    end

    desc '|OmekaRecipes| Move a pristine copy of the archives/files directory to the shared_path'
    task :move_files_to_shared, :except => { :no_release => true } do
      #run "touch #{shared_path}/db.ini"
      run "mkdir -p #{shared_path}/application/logs/"
      run "touch #{shared_path}/application/logs/erros.log"
    end

    desc '|OmekaRecipes| Deploy the plugins defined in the plugins hash'
    task :get_plugins do
      git_clone(plugins, 'plugins')
    end

    desc '|OmekaRecipes| Deploy the themes defined in the themes hash'
    task :get_themes do
      git_clone(themes, 'themes')
    end

    namespace :maintenance do
      desc <<-DESC
        |OmekaRecipes| Add a maitenance page for visitors. Disables your Omeka
        instance by writing a "#{maintenance_basename}.html" file to each web
        server. The servers must be configured to detect the presence of the file,
        and if it is present, display the maintenance page instead of performaning
        the request.

          $ cap omeka:maintenance:start \\
            REASON="hardware upgrade" \\
            UNTIL="12pm EST"

        You can use a different template for the maintenace page by setting the
        :maintenace_template_path variable in your deploy.rb. The template file
        should either be a plaintext or an erb file.
      DESC
      task :start, :roles => :web, :except => { :no_release => true } do
        require 'erb'
        on_rollback { run "rm -f #{shared_path}/system/maintenance.html" }

        warn <<-HTACCESS
          # Please add something like this to your site's Apache htaccess to redirect users to the maintenance page.
          # More Info: http://www.shiftcommathree.com/articles/make-your-rails-maintenance-page-respond-with-a-503

          ErrorDocument 503 /system/maintenance.html
          RewriteEngine On
          RewriteCond %{REQUEST_URI} !\.(css|gif|jpg|png)$
          RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
          RewriteCond %{SCRIPT_FILENAME} !maintenance.html
          RewriteRule ^.*$  -  [redirect=503,last]
        HTACCESS

        reason = ENV['REASON']
        deadline = ENV['UNTIL']

        template = File.read(maintenance_template_path)
        result = ERB.new(template).result(binding)

        put result, "#{shared_path}/system/maintenance.html", :mode => 0644
      end

      desc <<-DESC
      Enables the application web-accessible again. Removes the \n
      "maintenance.html" page generated by deploy:maitenance:start,
      which, (if your server is configured properly) will make Omeka web-
      accessible again.
      DESC
      task :end, :roles => :web, :except => { :no_release => true } do
        run "rm -f #{shared_path}/system/#{maintenance_basename}.html"
      end
    end
  end

  after 'deploy:cold', 'omeka:fix_files_permissions', 'omeka:move_files_dir'
  after 'deploy:setup', 'omeka:move_files_to_shared'
  #before 'deploy:create_symlink', 'omeka:move_files_dir'
  #after 'deploy:create_symlink', 'omeka:link_files_dir'
  after 'deploy', 'omeka:get_themes', 'omeka:get_plugins', 'omeka:rename_files'

end
