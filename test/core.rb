require File.expand_path('../test_helper', __FILE__)

module DataMapper
  module Model
    def destroy_all!; all.destroy!; end
  end
end

module FriendlyId
  module Test
    module DataMapperAdapter

      # Core tests for any datamapper model using FriendlyId.
      module Core

        def teardown
          klass.all.destroy!
          other_class.all.destroy!
          FriendlyId::DataMapperAdapter::Slug.all.destroy!
        end

        def find_method
          :get
        end

        def create_method
          :create
        end

        def delete_all_method
          :destroy_all!
        end

        def save_method
          :save
        end

        def validation_exceptions
          nil # DataMapper does not raise Validation Errors
        end

      end
    end
  end
end
