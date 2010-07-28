require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test
    module DataMapperAdapter

      # Tests for DataMapper models using FriendlyId without slugs.
      class BasicSimpleTest < ::Test::Unit::TestCase
        include FriendlyId::Test::Generic
        include FriendlyId::Test::Simple
        include FriendlyId::Test::DataMapperAdapter::Core
        include FriendlyId::Test::DataMapperAdapter::Simple
      end
    end
  end
end
