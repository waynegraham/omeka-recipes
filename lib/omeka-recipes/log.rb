Capistrano::Configuration.instance.load do
  namespace :log do
    
    desc "|OmekaRecipes| Tail all log files"
    task :tail, :roles => :app do
      run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
        puts "#{channel[:host]} #{data}"
        break if stream == :err
      end
    end

    desc "|OmekaRecipes| Install log rotation script; optional args:

    days=7, size=5M, group (defaults to same as user)"
    task :rotate, :roles => :app do
      rotate_script = %Q{#{shared_path}/log/error.log {
        daily
        rotate #{ENV['days']} || 7}
        size #{ENV['size'] || "5M"}
        compress
        create 640 #{user} #{ENV['group'] || user}
        missingok
      }}

      put rotate_script, "#{shared_path}/logroate_script"
      "#{sudo} cp #{shared_path}/logroate_script /etc/logrotate.d/#{application}"
      run "rm #{shared_path}/logroate_script" # clean up
    end

  end
end
