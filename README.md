# capistrano-multiproject

## Description

Capistrano extension that allows to deploy multiple projects from one location.

Everybody knows/uses original multistage extension written by Jamis Buck. It works great while you have only one project/app to deploy.
It is not quite enough if you have multiple projects to deploy (SOA would be one big use case here). Capistrano-multiproject solves this problem by allowing splitting up deploy.rb into multiple project-specific recipe files.

## Usage

Install gem

    $ gem install capistrano-multiproject


Add to `Capfile`

    require 'capistrano/multiproject'
