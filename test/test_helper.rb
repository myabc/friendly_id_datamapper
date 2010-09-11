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
# NOTE: dm-active_model is not a runtime requirement, as we implement
# #to_param for models. It is a testing requirement to ensure that our
# #to_param implementation overrides the default dm-active_model impl.
require 'dm-active_model'

DataMapper::Logger.new('dm.log', :debug)
DataMapper.setup(:default, 'sqlite3::memory:')

$LOAD_PATH << './lib'

require 'friendly_id_datamapper'
require File.expand_path('../core',    __FILE__)
require File.expand_path('../slugged', __FILE__)

require File.expand_path('../support/models', __FILE__)
DataMapper.finalize
DataMapper.auto_migrate!
