Capistrano::Configuration.instance.load do
  namespace :apache do
    [:stop, :start, :restart, :reload].each do |action|
      desc "|OmekaRecipes| #{action.to_s.capitalize} Apache"
      task action, :roles => :web do
        run "#{sudo} service #{web_server} #{action}", :via => run_method
      end
    end
  end
end
