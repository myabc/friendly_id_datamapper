require File.expand_path('../test_helper', __FILE__)

module FriendlyId
  module Test
    module DataMapperAdapter

      module Slugged

        def klass
          Post
        end

        def other_class
          District
        end

        def instance
          @instance ||= klass.create(:name => 'hello world')
        end

      end
    end
  end
end
