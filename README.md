<h1>Omeka::Recipes</h1>

<p><a href="http://travis-ci.org/waynegraham/omeka-recipes"><img src="https://secure.travis-ci.org/waynegraham/omeka-recipes.png" alt="Build Status" title="" /></a></p>

<p>Useful Capistrano recipes including:</p>

<ul>
<li>Create MySQL database and user on server (via prompts)</li>
<li>Restart/Stop/Start Apache/HTTPD server</li>
<li>Log rotation and tailing commands</li>
<li>Deploy Omeka</li>
</ul>

<h2>Included Tasks</h2>

<ul>
<li><code>cap apache:reload</code></li>
<li><code>cap apache:restart</code></li>
<li><code>cap apache:start</code></li>
<li><code>cap apache:stop</code></li>
<li><code>cap db:create_ini</code></li>
<li><code>cap db:myql:dump</code></li>
<li><code>cap db:myql:fetch_dump</code></li>
<li><code>cap db:myql:restore</code></li>
<li><code>cap db:mysql:setup</code></li>
<li><code>cap log:rotate</code></li>
<li><code>cap log:tail</code></li>
<li><code>cap omeka:db_ini</code></li>
<li><code>cap omeka:plugins</code></li>
<li><code>cap omeka:themes</code></li>
<li><code>cap symlinks:make</code></li>
</ul>

<h2>Installation</h2>

<p>Add this line to your application's Gemfile:</p>

<pre><code>gem 'omeka-recipes'
</code></pre>

<p>And then execute:</p>

<pre><code>$ bundle
</code></pre>

<p>Or install it yourself as:</p>

<pre><code>$ gem install omeka-recipes
</code></pre>

<h2>Usage</h2>

<p>To set up the initial Capistrano deploy file, go to your application
folder in the command line and enter the <code>capify</code> command:</p>

<p><code>bash
$ capify .
</code></p>

<h3>Configuration</h3>

<p>Inside a newly created <code>config/deploy.rb</code> file, add this:</p>

<p>```ruby
require 'capistrano/ext/multistage'</p>

<p>require 'omeka-recipes'
```</p>

<p>Now set up capistrano to do multistage </p>

<p><code>bash
cap multistage:prepare
</code></p>

<h3>Plugins</h3>

<p>Plugins are defined in the <code>plugins</code> hash, giving a plugin name, and it's
<code>git</code> repo. Be sure to use a <strong>read-only</strong> version.</p>

<p><code>ruby
set :plugins, {
  'Neatline' =&gt; 'git://github.com/scholarslab/Neatline.git',
  'NeatlineMaps' =&gt; 'git://github.com/scholarslab/NeatlineMaps.git',
  'CsvImport' =&gt; 'git://github.com/omeka/plugin-CsvImport.git',
  'Scripto' =&gt; 'git://github.com/omeka/plugin-Scripto.git'
}
</code></p>

<h3>Themes</h3>

<p>Themes are defined in the <code>themes</code> hash, passing a theme name and it's
<code>git</code> repository. </p>

<p><code>ruby
set :themes, {
  'neatline' =&gt; 'git://github.com/scholarslab/neatlinetheme.git',
  'emiglio' =&gt; 'git://github.com/omeka/theme-emiglio.git'
}
</code></p>

<h2>Example Configuration</h2>

<p>The following is an example of a <code>config/deploy.rb</code> file:</p>

<p>```ruby
set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'</p>

<p>require 'omeka-recipes'</p>

<p>set :application, "omeka"
set :repository,  "git://github.com/omeka/Omeka.git"</p>

<p>set :scm, :git</p>

<p>set :branch, 'stable-1.5'</p>

<p>set :plugins, {
  'Neatline' => 'git://github.com/scholarslab/Neatline.git',
  'NeatlineFeatures' => 'git://github.com/scholarslab/NeatlineFeatures.git',
  'NeatlineMaps' => 'git://github.com/scholarslab/NeatlineMaps.git',
  'NeatlineTime' => 'git://github.com/scholarslab/NeatlineTime.git',
  'SolrSearch' => 'git://github.com/scholarslab/SolrSearch.git',
}</p>

<p>set :themes, {
  'mcos-omeka-theme' => 'git://github.com/scholarslab/mcos-omeka-theme.git'
}</p>

<p>after "deploy:restart", "deploy:cleanup"
<code>``
In each of the stages of your deployment (e.g.
</code>deploy/deploy/production.rb`), you will need to add a definition to
tell capistrano where to go.</p>

<p><code>ruby
server 'server.org', :app, :web, :primary =&gt; true
</code></p>

<p>And your staging:</p>

<p><code>ruby
server 'staging.server.org', :app, :db, :web, :primary =&gt; true
</code></p>

<h3>RVM</h3>

<p>RVM is disabled by default, but you can enable it by setting <code>:use_rvm,
true</code>. You may also leverage it by setting your <code>rvm_ruby_string</code> to an
appropriate version (default is <code>1.9.3</code>).</p>

<p>If <code>using_rvm</code> is true, the rvm recipe will load the RVM capistrano
extensions so you don't have to worry about them during your
deployments. You will need to make sure you have an <code>.rvmrc</code> file in the
project directory, and system-wide installation on the servers.</p>

<p>See <a href="the rvm site">http://rvm.beginrescueend.com/rvm/install</a> for more information.</p>

<h1>Copyright</h1>

<p>See the <a href="https://github.com/waynegraham/omeka-recipes/blob/master/LICENSE">LICENSE</a> for more information.</p>

<h2>Contributing</h2>

<ol>
<li>Fork it</li>
<li>Create your feature branch (<code>git checkout -b my-new-feature</code>)</li>
<li>Commit your changes (<code>git commit -am 'Added some feature'</code>)</li>
<li>Push to the branch (<code>git push origin my-new-feature</code>)</li>
<li>Create a new Pull Request</li>
</ol>

<h2>Contributors</h2>

<ul>
<li>Jeremy Boggs (<a href="clioweb">clioweb</a>)</li>
<li>Wayne Graham (<a href="https://github.com/waynegraham">waynegraham</a>)</li>
</ul>
