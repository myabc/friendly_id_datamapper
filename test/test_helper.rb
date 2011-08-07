$LOAD_PATH << './lib'
require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'mocha'

require 'friendly_id'
require 'friendly_id/datamapper'
require 'friendly_id/test'

require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
# NOTE: dm-active_model is not a runtime requirement, as we implement
# #to_param for models. It is a testing requirement to ensure that our
# #to_param implementation overrides the default dm-active_model impl.
require 'dm-active_model'

DataMapper::Logger.new('dm.log', :debug)
DataMapper.setup(:default, 'sqlite3::memory:')

require File.expand_path('../core',    __FILE__)
require File.expand_path('../slugged', __FILE__)
require File.expand_path('../support/models', __FILE__)

DataMapper.finalize
DataMapper.auto_migrate!
