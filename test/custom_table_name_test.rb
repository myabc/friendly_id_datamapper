require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test
    module DataMapperAdapter

      class CustomTableNameTest < ::Test::Unit::TestCase

        include FriendlyId::Test::Generic
        include FriendlyId::Test::Slugged
        include FriendlyId::Test::DataMapperAdapter::Slugged
        include FriendlyId::Test::DataMapperAdapter::Core

        def klass
          Place
        end

      end

    end
  end
end
