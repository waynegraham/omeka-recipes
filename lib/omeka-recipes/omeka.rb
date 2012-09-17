Capistrano::Configuration.instance.load do

  set :omeka_branch, "master" unless exists?(:omeka_branch)

  def git_clone(hash, directory)
    hash.each do |name, location|
      run "cd #{current_path}/#{directory} && rm -rf #{name}"
      run "cd #{current_path}/#{directory} && git clone #{location} --quiet"
    end
  end

  namespace :omeka do
    desc 'Ensure the archive directory has write permissions'
    task :fix_archive_permissions do
      # This _should_ actually change the permissions of the archive directory to
      # be the owner of process running httpd/apache2 daemon.
      run "chmod -R 777 #{current_path}/archive"
    end

    desc 'Rename files'
    # Omeka stages these files in its repo
    task :rename_files do
      run "cd #{current_path} && mv .htaccess.changeme .htaccess"
      run "cd #{current_path}/application/config && mv config.ini.changeme config.ini"
    end

    desc 'Move the archive directory out of the way'
    task :move_archive_dir do
      run "mv #{current_path}/archive #{current_path}/archive_deleteme"
    end

    desc 'Link the archive directoy for the project'
    task :link_archive_dir, :except => {:no_release => true} do
      run "cd #{current_path} && ln -snf #{shared_path}/archive"
    end

    desc 'Add the db.ini to the shared directory'
    task :db_ini do
      run "touch #{shared_path}/db.ini"
    end

    desc 'Deploy the plugins defined in the plugins hash'
    task :get_plugins do
      git_clone(plugins, 'plugins')
    end

    desc 'Deploy the themes defined in the themes hash'
    task :get_themes do
      git_clone(themes, 'themes')
    end

  end

  after 'deploy:cold', 'omeka:fix_archive_permissions', 'omeka:move_archive_dir'
  #before 'deploy:create_symlink', 'omeka:move_archive_dir'
  after 'deploy:create_symlink', 'omeka:link_archive_dir'
  after 'deploy', 'omeka:get_themes', 'omeka:get_plugins', 'omeka:rename_files'

end
