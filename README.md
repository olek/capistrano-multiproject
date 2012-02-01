capistrano-multiproject
=======================

Author: Olek Poplavsky


Introduction
------------

Capistrano extension that allows to deploy multiple projects from one location.

Everybody knows/uses original multistage extension written by Jamis Buck. It works great while you
have only one project/app to deploy.  It is not quite enough if you have multiple projects to deploy
(SOA would be one big use case here). Capistrano-multiproject solves this problem by allowing
splitting up deploy.rb into multiple project-specific recipe files.


Installation
------------

Install gem

    $ gem install capistrano-multiproject


Setup
-----

You are expected to create separate project, whole purpose of which is to deploy other projects.
That may be just a directory in your source repository, or a separate repository, it is up to you.

**Typical directory structure of 'deploy' project**

    config/
      deploy/
        projects/
          project1.rb
          project2.rb
        stages/
          testing.rb
          qa.rb
          demo.rb
          production.rb
      deploy.rb
    recipes/
      recipe1.rb
      recipe2.rb
    Capfile
    Gemfile


Usage
-----

If your run 'cap -T' you will see that only tasks that are loaded by default are projects, stages,
and strange '?' task. That last one is actually a replacement for  '-T' option, that is customized
for the multiproject setup.

'cap ?' outputs list of stages.

'cap stage1 ?' outputs list of projects.

'cap stage1 project1 ?' outputs list of capistrano tasks available in a given project.

'cap stage1 project1 task1' executes capistrano task for some project in a context of given stage.


Configuration
-------------

Add to `Gemfile`

    gem 'capistrano'
    gem 'capistrano-multiproject'

Add to `Capfile`

    require 'capistrano/multiproject'
    load 'config/deploy'

Create file config/deploy.rb. Put you common settings/recipes there, those will be shared by all
projects. Settings like 'scm', 'repository', 'use_sudo', 'ssh_options' are good candidates to put
here.
Require common shared recipes like this:

    load 'recipes/recipe1.rb'

Create directories deploy/projects and deploy/stages.

Stages directory contains .rb files that describe settings particular to specific stage. Usually all
that is done here is setting branch (or repository) and bunch of server roles.

Example of stage file config/deploy/stages/stage1.rb:

    role :app, 'app1.foo.com', 'app2.foo.com'
    role :redis, 'misc.foo.com'
    role :shpinx, 'misc.foo.com'
    role :db, 'masterdb.foo.com', :primary => true, :master => true
    role :db,  'slavedb.foo.com', :no_release => true, :master => false
    set :branch, 'master'

Projects directory contains .rb files that contains recipes specifit to particular project.

Example config/deploy/projects/foo.rb:

    load 'recipes/recipe1.rb'

    set :shared_children, %w(log pids)

    namespace :deploy  do
      desc "Stops foo service"
      task :stop do
        run "#{sudo} /etc/init.d/foo stop"
      end

      desc "Starts foo service"
      task :start do
        run "#{sudo} /etc/init.d/foo start"
      end

      desc "Restarts foo service"
      task :restart do
        run "#{sudo} /etc/init.d/foo restart"
      end
    end

By default, only roles that are named the same as project file, are loaded (that is, for project
'foo.rb', only role 'foo' will be loaded, roles 'db', 'redis' etc will not make it to capistrano.
When this needs to be customized, it is easy to do that my setting property project_roles like this:

    set :project_roles, ['role1', 'role2']

In addition to roles defined in stage file, project's recipes have access to one special/synthetic 'any_server' role.
That role contains all the servers that were defined in the stage file, combined. It is very useful
to implement some administration recipes, like 'reboot all servers', 'update ubuntu software on all
servers', or 'run chef-client on all servers'.

Example config/deploy/projects/admin.rb:

    set :project_roles, %w(any_server)
    namespace :servers do
      namespace :reboot do
        desc "Reboot all servers"
        task :all do
          run "#{sudo} shutdown -r +1" # reboot in 1 minute
        end
      end
    end


Compatibility
-------------

So far it was tested to work under ruby 1.9.

There is no good reason why it would not work with ruby 1.8, if you find problem with that, come
back to me and we will fix it together :)


License
-------

capistrano-multiproject is released under the [MIT][license] license.

[license]: http://www.opensource.org/licenses/MIT


Credits
-------

**Jamis Buck**

  [capistrano-multistage][multistage] started it all

**Andriy Yanko**

  [caphub][caphub] and [capistrano-multiconfig][multiconfig] were the inspiration for this project

[multistage]: http://weblog.jamisbuck.org/2007/7/23/capistrano-multistage
[caphub]: https://github.com/railsware/caphub
[multiconfig]: https://github.com/railsware/capistrano-multiconfig
