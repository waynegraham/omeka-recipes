# Omeka::Recipes

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
* `cap db:mysql:create_ini`
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
$ cap multistage:prepare
```

### Configuration

Inside a newly created `config/deploy.rb` file, add this:

```ruby
require 'capistrano/ext/multistage'

# This should go at the end of the deploy.rb file
require 'capistrano_omeka'
```

### Plugins
Plugins are defined in the `plugins` hash, giving a plugin name, and it's
`git` repo. Be sure to use a **read-only** version.

```ruby
plugins = {
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
themes = {
  'neatline' => 'git://github.com/scholarslab/neatlinetheme.git'
  'emiglio' => 'git://github.com/omeka/theme-emiglio.git'
}
```
## Example Config

The following is an example of a `config/deploy.rb` file:

```ruby
set :stages, %(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

require 'omeka-recipes'

set :application, "omeka"
set :repository,  "git://github.com/omeka/Omeka.git"

set :scm, :git

plugins = {
  'Neatline' => 'git://github.com/scholarslab/Neatline.git',
  'NeatlineFeatures' => 'git://github.com/scholarslab/NeatlineFeatures.git',
  'NeatlineMaps' => 'git://github.com/scholarslab/NeatlineMaps.git',
  'NeatlineTime' => 'git://github.com/scholarslab/NeatlineTime.git',
  'SolrSearch' => 'git://github.com/scholarslab/SolrSearch.git',
}

themes = {
  'mcos-omeka-theme' => 'git://github.com/scholarslab/mcos-omeka-theme.git'
}
```


### RVM

RVM is enabled by default, but you can disable it by setting `:use_rvm,
false`. You may also leverage it by setting your `rvm_ruby_string` to an
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
5. Create new Pull Request
