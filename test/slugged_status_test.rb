require File.expand_path('../test_helper', __FILE__)

::Slug = ::FriendlyId::DataMapperAdapter::Slug

module FriendlyId
  module Test
    module DataMapperAdapter

      class StatusTest < ::Test::Unit::TestCase

        include FriendlyId::Test::Status
        include FriendlyId::Test::SluggedStatus

        def klass
          Post
        end

        def instance
          @instance ||= klass.create :name => "hello world"
        end

        def find_method
          :get
        end

      end
    end
  end
end
