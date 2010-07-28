require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test
    module DataMapperAdapter

      class CustomNormalizerTest < ::Test::Unit::TestCase

        include FriendlyId::Test::DataMapperAdapter::Core
        include FriendlyId::Test::DataMapperAdapter::Slugged
        include FriendlyId::Test::CustomNormalizer

        def klass
          Person
        end

      end
    end
  end
end
