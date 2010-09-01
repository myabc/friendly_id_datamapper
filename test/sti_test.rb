require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test
    module DataMapperAdapter

      class StiTest < ::Test::Unit::TestCase

        include FriendlyId::Test::Generic
        include FriendlyId::Test::Slugged
        include FriendlyId::Test::DataMapperAdapter::Core
        include FriendlyId::Test::DataMapperAdapter::Slugged

        def klass
          Novel
        end

      end
    end
  end
end
