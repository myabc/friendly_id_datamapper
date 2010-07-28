require 'friendly_id/finders'

module FriendlyId
  module DataMapperAdapter

    module SimpleModel

      class SingleFinder

        include FriendlyId::Finders::Base
        include FriendlyId::Finders::Single

        def find
          result = model_class.first(options.merge!(friendly_id_config.column.to_sym => id))
          result
        end

      end

      def self.included(base)
        base.class_eval do
          column = friendly_id_config.column
          validates_presence_of column, :unless => :skip_friendly_id_validations
          validates_length_of   column, :maximum => friendly_id_config.max_length, :unless => :skip_friendly_id_validations
          validates_with_method column, :method => :validate_friendly_id, :unless => :skip_friendly_id_validations
        end

        def base.get(*key)
          if key.size == 1
            repository = self.repository
            key        = self.key(repository.name).typecast(key)
            SingleFinder.new(key, self).find or super
          else
            super
          end
        end
      end

      # Get the {FriendlyId::Status} after the find has been performed.
      def friendly_id_status
        @friendly_id_status ||= Status.new :record => self
      end

      # Returns the friendly_id.
      def friendly_id
        send self.class.friendly_id_config.column
      end

      # Returns the friendly id, or if none is available, the numeric id.
      def to_param
        (friendly_id || id).to_s
      end

      private

      def friendly_id_config
        self.class.friendly_id_config
      end

      def skip_friendly_id_validations
        friendly_id.nil? && friendly_id_config.allow_nil?
      end

      def validate_friendly_id
        if result = friendly_id_config.reserved_error_message(friendly_id)
          return [false, result.join(' ')]
        else
          return true
        end
      end

    end
  end
end
