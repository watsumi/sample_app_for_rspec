source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '~> 5.2.3'
gem 'sqlite3'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'sorcery'

group :development, :test do
  gem 'rspec-rails', '~> 4.0.1'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.10.0'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'rubocop'
  gem 'rails_best_practices'
  gem 'spring-commands-rspec'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
