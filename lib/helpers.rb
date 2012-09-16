# =========================================================================
# Helper methods for the recipes
# =========================================================================

# Automatically ests the environment based on presence of
# :stage (multistage gem), :rails_env, or RAILS_ENV variable; otherwise
# defaults to 'production'
def environment
  if exists?(:stage)
    stage
  elsif exists(:rails_env)
    rails_env
  elsif(ENV['RAILS_ENV'])
    ENV['RAILS_ENV']
  else
    "production"
  end
end

def is_using(something, with_some_var)
  exists?(with_some_var.to_sym) && fetch(with_some_var.to_sym).to_s.downcase == something
end

# Path where generators live
def templates_path
  expand_path_for('../generators')
end

def docs_path
  expand_path_for('../doc')
end

def expand_path_for(path)
  expanded = File.join(File.dirname(__FILE__), path)
  File.expand_path(expanded)
end

def parse_config(file)
  require 'erb' # render not available in Capistrano 2
  template = File.read(file) 
  return ERB.new(template).result(binding)
end

# Prompt user for a message
def ask(message, default=true)
  Capistrano::CLI.ui.agree(message)
end

# Generate a configuration file for parsing through ERB
# Fetches file and uploads it to remote_file
# Make suer you user has the correct permissions
def generate_config(local_file, remote_file)
  temp_file = '/tmp' + File.basename(local_file)
  buffer = parse_config(local_file)
  File.open(temp_file, 'w+') { |f| f << buffer }
  upload temp_file, remote_file, :via => :scp
  `rm #{temp_file}`
end

# Executes a basic rake task
def run_rake(task)
  run "cd #{current_path} && rake #{task} RAILS_ENV=#{environment}"
end
