# Omeka::Recipes
[![Build Status](https://secure.travis-ci.org/waynegraham/omeka-recipes.png)](http://travis-ci.org/waynegraham/omeka-recipes)

Useful Capistrano recipes including:

* Create MySQL database and user on server (via prompts)
* Restart/Stop/Start Apache/HTTPD server
* Log rotation and tailing commands
* Deploy Omeka

## Included Tasks

* cap apache:reload                 
* cap apache:restart                
* cap apache:start                 
* cap apache:stop                 
* cap db:create_ini              
* cap db:mysql:dump             
* cap db:mysql:fetch_dump      
* cap db:mysql:restore        
* cap db:mysql:setup                
* cap deploy                       
* cap deploy:seppuku              
* cap deploy:setup_dirs          
* cap deploy:symlink            
* cap log:rotate               
* cap log:tail                   
* cap omeka:db_ini                
* cap omeka:fix_archive_permissions
* cap omeka:get_plugins            
* cap omeka:get_themes              
* cap omeka:link_archive_dir    
* cap omeka:maintenance:start  
* cap omeka:move_archive_dir  
* cap omeka:move_files_to_shared
* cap omeka:rename_files       
* cap symlinks:make          

## Installation

Add this line to your application's Gemfile:

    gem 'omeka-recipes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omeka-recipes
 
## Usage

To set up the initial Capistrano deploy file, go to your application folder in the command line and enter the `capify` command:

```bash
$ capify .
```

### Configuration

Inside a newly created `config/deploy.rb` file, add this:

```ruby
require 'capistrano/ext/multistage'

require 'omeka-recipes'
```

Now set up capistrano to do multistage 

```bash
cap multistage:prepare
```

### Plugins
Plugins are defined in the `plugins` hash. Each plugin is defined by a git repository and a branch that should be checked out during deployment. Be sure to reference a **read-only** version of the git repository location:

```ruby
set :plugins, {
  'Neatline' => {
    :url => 'git://github.com/scholarslab/Neatline.git',
    :branch => 'develop'
  },
  'NeatlineWaypoints' => {
    :url => 'git://github.com/scholarslab/nl-widget-Waypoints.git',
    :branch => 'master'
  }
  'NeatlineSimile' => {
    :url => 'git://github.com/scholarslab/nl-widget-Simile.git',
    :branch => 'master'
  }
  'Scripto' => {
    :url => 'git://github.com/omeka/plugin-Scripto.git',
    :branch => 'master'
  }
}
```

### Themes

Themes are defined in the `themes` hash. As with the plugins, define each theme with a git repository location and branch: 

```ruby
set :themes, {
  'neatlight' => {
    :url => 'git://github.com/davidmcclure/neatlight.git',
    :branch => 'master'
  },
  'emiglio' => {
    :url => 'git://github.com/omeka/theme-emiglio.git',
    :branch => 'master'
  }
}
```
## Example Configuration

The following is an example of a `config/deploy.rb` file:

```ruby
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

require 'omeka-recipes'

set :application, "omeka"
set :repository,  "git://github.com/omeka/Omeka.git"

set :scm, :git

set :branch, 'stable-1.5'

set :plugins, {
  'Neatline' => 'git://github.com/scholarslab/Neatline.git',
  'NeatlineFeatures' => 'git://github.com/scholarslab/NeatlineFeatures.git',
  'NeatlineMaps' => 'git://github.com/scholarslab/NeatlineMaps.git',
  'NeatlineTime' => 'git://github.com/scholarslab/NeatlineTime.git',
  'SolrSearch' => 'git://github.com/scholarslab/SolrSearch.git',
}

set :themes, {
  'mcos-omeka-theme' => 'git://github.com/scholarslab/mcos-omeka-theme.git'
}

after "deploy:restart", "deploy:cleanup"
```
In each of the stages of your deployment (e.g.
`config/deploy/production.rb`), you will need to add a definition to
tell capistrano where to go.

```ruby
server 'server.org', :app, :web, :primary => true
```

And your staging:

```ruby
server 'staging.server.org', :app, :db, :web, :primary => true
```


### RVM

RVM is disabled by default, but you can enable it by setting `:use_rvm, true`. You may also leverage it by setting your `rvm_ruby_string` to an appropriate version (default is `1.9.3`).

If `using_rvm` is true, the rvm recipe will load the RVM capistrano extensions so you don't have to worry about them during your deployments. You will need to make sure you have an `.rvmrc` file in the project directory, and system-wide installation on the servers.

See [http://rvm.beginrescueend.com/rvm/install](the rvm site) for more information.

# Copyright

See the [LICENSE](https://github.com/waynegraham/omeka-recipes/blob/master/LICENSE) for more information.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

* Jeremy Boggs ([clioweb](clioweb))
* Wayne Graham ([waynegraham](https://github.com/waynegraham))
* David McClure ([davidmcclure](https://github.com/davidmcclure))

