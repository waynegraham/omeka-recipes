

def fetch_db_ini
  require 'fileutils'
  require 'IniFile'
  
  file_path = "./db.ini"
  @db_config = IniFile.new(:filename => file_path).to_h
end

def prepare_from_ini
puts @db_config['database']['username']
puts @db_config['database']['password']
puts @db_config['database']['host']
puts @db_config['database']['name']
puts @db_config['database']['prefix']
puts @db_config['database']['charset']

end

fetch_db_ini
test = prepare_from_ini


