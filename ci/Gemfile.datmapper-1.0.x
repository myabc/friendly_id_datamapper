source :rubygems

gemspec

gem 'dm-core',            '~> 1.0.2'
gem 'dm-migrations',      '~> 1.0.2'
gem 'dm-validations',     '~> 1.0.2'
gem 'dm-mysql-adapter',   '~> 1.0.2'
gem 'dm-sqlite-adapter',  '~> 1.0.2'
gem 'dm-active_model',    '~> 1.0.2'
gem 'dm-transactions',    '~> 1.0.2'

group :development do
  gem 'rake', '~> 0.8.7'
end

group :test do
  gem 'mocha'
end
