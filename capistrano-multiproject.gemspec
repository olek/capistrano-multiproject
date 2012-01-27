# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "capistrano-multiproject"
  s.version     = "0.0.2"
  s.authors     = ["Olek Poplavsky"]
  s.email       = ["olek@woodenbits.com"]
  s.homepage    = "https://github.com/woodenbits/capistrano-multiproject"
  s.date        = '2012-01-26'

  s.summary     = 'Capistrano extension that allows to deploy multiple projects from one location'
  s.description = %q{
Everybody knows/uses original multistage extension written by Jamis Buck. It works great while you have only one project/app to deploy.
It is not quite enough if you have multiple projects to deploy (SOA would be one big use case here). Capistrano-multiproject solves this problem by allowing splitting up deploy.rb into multiple project-specific recipe files.
  }
  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('capistrano', "~> 2.9.0")

  s.files = %w[
    capistrano-multiproject.gemspec
    Gemfile
    lib/capistrano/multiproject/configurations.rb
    lib/capistrano/multiproject/ensure.rb
    lib/capistrano/multiproject/filter_roles.rb
    lib/capistrano/multiproject/any_server_role.rb
    lib/capistrano/multiproject/task_list.rb
    lib/capistrano/multiproject.rb
    Rakefile
    README.md
  ]
end

