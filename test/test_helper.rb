# Use Bundler (preferred)
begin
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require 'active_support'
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
require File.expand_path('../simple',  __FILE__)
require File.expand_path('../slugged', __FILE__)

#require File.dirname(__FILE__) + "/../lib/friendly_id/datamapper_adapter/slug"


class Book
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :unique => true
  property :note, String

  has_friendly_id :name
end

class User
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :unique => true
  property :note, String

  has_friendly_id :name
end

class Animal; end
class Cat; end
class City; end
class Post; end
class Person
  def normalize_friendly_id(string)
    string.upcase
  end
end

[Animal, Cat, City, Post, Person].each do |clazz|
  clazz.class_eval do
    include DataMapper::Resource
    property :id,   DataMapper::Types::Serial
    property :name, String #, :unique => true
    property :note, String

    has_friendly_id :name, :use_slug => true
  end
end

DataMapper.auto_migrate!
