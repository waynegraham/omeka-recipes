# Omeka::Recipes

[![Build Status](https://secure.travis-ci.org/waynegraham/omeka-recipes.png)](http://travis-ci.org/waynegraham/omeka-recipes)

Useful Capistrano recipes including:

* Create MySQL database and user on server (via prompts)
* Restart/Stop/Start Apache/HTTPD server
* Log rotation and tailing commands
* Deploy Omeka

## Included Tasks

* `cap apache:reload`
* `cap apache:restart`
* `cap apache:start`
* `cap apache:stop`
* `cap db:create_ini`
* `cap db:myql:dump`
* `cap db:myql:fetch_dump`
* `cap db:myql:restore`
* `cap db:mysql:setup`
* `cap log:rotate`
* `cap log:tail`
* `cap omeka:db_ini`
* `cap omeka:plugins`
* `cap omeka:themes`
* `cap symlinks:make`

## Installation

Add this line to your application's Gemfile:

    gem 'omeka-recipes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omeka-recipes
 
## Usage

To set up the initial Capistrano deploy file, go to your application
folder in the command line and enter the `capify` command:

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
Plugins are defined in the `plugins` hash, giving a plugin name, and it's
`git` repo. Be sure to use a **read-only** version.

```ruby
set :plugins, {
  'Neatline' => 'git://github.com/scholarslab/Neatline.git',
  'NeatlineMaps' => 'git://github.com/scholarslab/NeatlineMaps.git',
  'CsvImport' => 'git://github.com/omeka/plugin-CsvImport.git',
  'Scripto' => 'git://github.com/omeka/plugin-Scripto.git'
}
```

### Themes

Themes are defined in the `themes` hash, passing a theme name and it's
`git` repository. 

```ruby
set :themes, {
  'neatline' => 'git://github.com/scholarslab/neatlinetheme.git',
  'emiglio' => 'git://github.com/omeka/theme-emiglio.git'
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
`deploy/deploy/production.rb`), you will need to add a definition to
tell capistrano where to go.

```ruby
server 'server.org', :app, :web, :primary => true
```

And your staging:

```ruby
server 'staging.server.org', :app, :db, :web, :primary => true
```


### RVM

RVM is disabled by default, but you can enable it by setting `:use_rvm,
true`. You may also leverage it by setting your `rvm_ruby_string` to an
appropriate version (default is `1.9.3`).

If `using_rvm` is true, the rvm recipe will load the RVM capistrano
extensions so you don't have to worry about them during your
deployments. You will need to make sure you have an `.rvmrc` file in the
project directory, and system-wide installation on the servers.

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
