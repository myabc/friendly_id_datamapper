require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test
    module DataMapperAdapter

      module Slugged

        def klass
          Post
        end

        def other_class
          City
        end

        def instance
          @instance ||= klass.send(create_method, :name => "hello world")
        end

      end
    end
  end
end
