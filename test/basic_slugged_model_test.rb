require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test
    module DataMapperAdapter

      # Tests for DataMapper models using FriendlyId with slugs.
      class BasicSluggedModelTest < ::Test::Unit::TestCase
        include FriendlyId::Test::Generic
        include FriendlyId::Test::Slugged
        include FriendlyId::Test::DataMapperAdapter::Slugged
        include FriendlyId::Test::DataMapperAdapter::Core
      end
    end
  end
end
