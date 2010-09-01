# Use Bundler (preferred)
begin
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require "friendly_id"
require "friendly_id/test"
require "logger"
require "test/unit"
require "mocha"

require 'forwardable'

require 'dm-core'
require 'dm-validations'
require 'dm-migrations'

DataMapper.setup(:default, 'sqlite3::memory:')
logger  = DataMapper::Logger.new('dm.log', :debug)

$LOAD_PATH << './lib'

require 'friendly_id_datamapper'
require File.expand_path('../core',    __FILE__)
require File.expand_path('../slugged', __FILE__)

require File.expand_path('../support/models', __FILE__)
DataMapper.finalize
DataMapper.auto_migrate!
