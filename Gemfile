source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Jquery turbolinks
gem 'jquery-turbolinks'
# Use foundation for styling
gem 'foundation-rails'
# Use Carrierwave for pictures
gem 'carrierwave'
# Use for picture storage
gem 'cloudinary'
# Use simple-forms for creating Simple-forms
gem 'simple_form'
# Use enum_help for enumerable types in forms
gem 'enum_help'
# Use will paginate for pagination
gem 'will_paginate', '~> 3.1.0'
# Use whenever for Chron Jobs
gem 'whenever'
# Use for keeping secrets secret.
gem 'figaro'
# Use for payments
gem 'stripe'
# Use devise for authentication
gem 'devise'
# Use cancancan for authorization
gem 'cancancan'
# Use Datagrid to create sortable tables
gem 'datagrid'
# admin portal
# gem 'rails_admin'
gem 'activeadmin'
# Date Validation
gem 'validates_timeliness', '~> 4.0'
gem 'date_validator'
# Use jquery-ui as a supplement to jquery
gem 'jquery-ui-rails'
# User autocomplete for searching universities
gem 'rails-jquery-autocomplete'
# Font Awesome for Icons
gem "font-awesome-rails"
# contact form mailer
gem 'mail_form'
# async mailjob framework
gem 'sucker_punch', '~> 2.0'
gem 'seed_dump'


# For use when deploying to heroku
gem 'rails_12factor', group: :production

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby "2.3.3"
