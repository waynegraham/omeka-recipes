require 'erb'

Capistrano::Configuration.instance.load do
  namespace :db do
    namespace :mysql do

      desc "|OmekaRecipes| Performs a compressed database dump. \n
      WARNING: This locks your database tables for the duraction of the mysqldump."
      task :dump, :roles => :db, :only => { :primary => true } do
        prepare_from_ini
        run "mysqldump --user=#{username} --host=#{host} -p #{db_name} | bzip2 -z9 > #{db_remote_file}" do |channel, stream, out|
          ch.send_data "#{password}\n" if out =~ /^Enter password:/
          puts out
        end
      end

      desc "|OmekaRecipes| Restores the database from the latest compressed dump"
      task :restore, :roles => :db, :only => { :primary => true } do
        prepare_from_ini
        run "bzcat #{db_remote_file} | mysql --user=#{username} -p --host=#{host} #{db_name}" do |channel, stream, out|
          ch.send_data "#{password}" if out =~ /^Enter password:/
          puts out
        end
      end

      desc "|OmekaRecipes| Downloads the compressed database dump to this machine"
      task :fetch_dump, :roles => :db, :only => { :primary => true } do
        prepare_from_ini
        download db_remote_file, db_local_file, :via => :scp
      end

      desc "OmekaRecipes| Create MySQL database and user for this environment using promted values"
      task :fetch_dump, :roles => :db, :only => { :primary => true } do
        prepare_for_db_command

        sql = <<-SQL
          CREATE DATABASE #{database}
          GRANT ALL PRIVELEGES ON #{database}.* 
          TO #{username}@localhost
          INDENTIFIED BY '#{password}'
          SQL

          run "mysql --user=#{username} -p --execute=\"#{sql}\"" do |channel, stream, data|
            if data =~ /^Enter password:/
              pass = Capistrano::CLI.password_prompt "Enter database password for '#{db_admin_user}':"
              channel.send_data "#{pass}\n"
            end
          end
      end

      desc "|OmekaRecipes| Create db.ini in shared path with settings for current stage and test env"
      task :create_ini do
        set(:username) { Capistrano::CLI.ui.ask "Enter #{environment} database username:" }
        set(:password) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }

        db_config = ERB.new <<-EOF
        [database]
        host = localhost
        username = #{username}
        password = #{password}
        dbname = #{application}_#{environment}
        prefix = omeka_
        charset = utf8
        EOF

        put db_config.result, "#{shared_path}/db.ini"
      end
    end


    # Sets database variables
    def prepare_from_ini
      set(:db_file) { "#{application}-dump.sql.bz2" }
      set(:db_remote_file) { "#{shared_path}/backup/#{db_file}" }
      set(:db_local_file) { "tmp/#{db_file}" }
      set(:username) { db_config["username"] }
      set(:password) { db_config["password"] }
      set(:host) { db_config["host"] }
      set(:database) { db_config["dbname"] }
      set(:prefix) { db_config["prefix"] }
      set(:charset) { db_config["charset"] }
    end

    def db_config
      @db_config ||= fetch_db_ini
    end

    def fetch_db_ini
      require 'IniFile'
      file = capture "cat #{shared_path}/db.ini"
      db_config = IniFile.new(file)
    end

    def prepare_for_db_command
      set :database, "#{application}_#{environment}"
      set(:db_admin_user) { Capistrano::CLI.ui.ask "Username with priviledged database access (to create database):" }
      set(:username) { Capistrano::CLI.ui.ask "Enter #{environment} database username:" }
      set(:password) { Capistrano::CLI.password_prompt "Enter #{environment} database password:" }
    end

    after "deploy:setup" do
      db.create_ini if Capistrano::CLI.ui.agree("Create db.ini in application's shared path? [Yn]")
    end

  end
end
