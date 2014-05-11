source 'https://rubygems.org'

if ENV['CI']
  ruby RUBY_VERSION
else
  ruby '2.1.1'
end

gem 'dotenv'
gem 'grape'
gem 'pg'
gem 'puma'
gem 'sequel'
gem 'sinatra-assetpack', :require => 'sinatra/assetpack'
gem 'sinatra'
gem 'uglifier'
gem 'rake'

group :test do
  gem 'database_cleaner'
  gem 'debugger'
  gem 'factory_girl'
  gem 'ffaker'
  gem 'rack-test'
  gem 'rspec'
end
