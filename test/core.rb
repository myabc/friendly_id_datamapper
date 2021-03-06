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
          Slug.all.destroy!
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

        def unfriendly_class
          Unfriendly
        end

        def validation_exceptions
          nil # DataMapper does not raise Validation Errors
        end

        test "should return their friendly_id for #to_param" do
          assert_match(instance.friendly_id, instance.to_param)
        end

        # This emulates a fairly common issue where id's generated by fixtures are very high.
        test "should continue to admit very large ids" do
          klass.repository(:default).adapter.select("INSERT INTO #{klass.storage_name} (id, name) VALUES (2047483647, 'An instance')")
          assert_nothing_raised do
            klass.get(2047483647)
          end
        end

        test "should not change failure behavior for models not using friendly_id" do
          assert_raise DataMapper::ObjectNotFoundError do
            unfriendly_class.get!(-1)
          end
        end

        test "failing finds with unfriendly_id should raise errors normally" do
          assert_raise DataMapper::ObjectNotFoundError do
            klass.get!(0)
          end
        end
      end
    end
  end
end
