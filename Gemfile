# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |_repo| 'https://github.com/#{repo}.git' }

ruby '3.1.2'

gem 'bootsnap', require: false
gem 'importmap-rails'
gem 'jbuilder'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap', '~> 5.2', '>= 5.2.3'
gem 'devise', '~> 4.9', '>= 4.9.2'
gem 'httparty'
gem 'mail_form'
gem 'omniauth-github', '~> 2.0', '>= 2.0.1'
gem 'omniauth-google-oauth2', '~> 1.1', '>= 1.1.1'
gem 'omniauth-rails_csrf_protection', '~> 1.0', '>= 1.0.1'
gem 'sassc-rails', '~> 2.1', '>= 2.1.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
