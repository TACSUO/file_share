# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

FileShare::Application.load_tasks

excluded_files = %w(config/database.yml public/files)

Jeweler::Tasks.new do |gem|
  gem.name = "file_share"
  gem.summary = %Q{Provides basic file management features.}
  gem.description = %Q{Simple versioned event management for Rails 3.}
  gem.email = ["jason.lapier@gmail.com", "jeremiah@inertialbit.net"]
  gem.homepage = "http://github.com/inertialbit/file_share"
  gem.authors = ["Jason LaPier", "Jeremiah Heller"]
  gem.require_path = 'lib'
  gem.files =  FileList[
    "[A-Z]*",
    "{app,config,lib,public,spec,test}/**/*",
    "db/**/*.rb"
  ]
  excluded_files.each{|f| gem.files.exclude(f)}

  gem.add_dependency 'rails', '3.0.7'
  gem.add_dependency 'formtastic'

  gem.add_development_dependency 'jeweler'
  gem.add_development_dependency "acts_as_fu"
  gem.add_development_dependency "capybara"
  gem.add_development_dependency "cucumber-rails"
  gem.add_development_dependency "rcov"
  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency 'sqlite3'

  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
end
